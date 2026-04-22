BEGIN
  ORDS.DEFINE_HANDLER(
    p_module_name => 'CDSS', p_pattern => 'patient_info/:run/:year', p_method => 'GET',
    p_source_type => 'plsql/block',
    p_source => q'[
DECLARE
  v_name      VARCHAR2(300);
  v_age       NUMBER;
  v_gender    VARCHAR2(20);
  v_icd_name  VARCHAR2(500);
  v_drug_name VARCHAR2(500);
BEGIN
  BEGIN
    EXECUTE IMMEDIATE
      'SELECT TRIM(PRENAME||'' ''||NAME||'' ''||SURNAME),' ||
      ' AGE_YEAR,' ||
      ' CASE SEX WHEN ''M'' THEN ''ชาย'' WHEN ''F'' THEN ''หญิง'' ELSE NVL(SEX,''ไม่ระบุ'') END' ||
      ' FROM patients@pmk' ||
      ' WHERE RUN_HN=' || TO_NUMBER(:run) ||
      ' AND YEAR_HN=' || TO_NUMBER(:year) ||
      ' AND ROWNUM=1'
    INTO v_name, v_age, v_gender;
  EXCEPTION WHEN OTHERS THEN v_name := NULL; v_age := NULL; v_gender := NULL;
  END;

  APEX_JSON.open_object;
  APEX_JSON.write('hn',           :run || '/' || :year);
  APEX_JSON.write('patient_name', v_name);
  APEX_JSON.write('age',          v_age);
  APEX_JSON.write('gender',       v_gender);

  APEX_JSON.open_array('diagnoses');
  BEGIN
    FOR r IN (
      SELECT op.icd_code,
             NVL(dm.DX_GROUP, op.icd_code) icd_group,
             TO_CHAR(MAX(op.date_created), 'YYYY-MM-DD') last_date
      FROM   opddiags@pmk op
      LEFT JOIN CDSS_DX_MAP dm ON dm.ICD_CODE = op.icd_code AND dm.ACTIVE_FLAG = 'Y'
      WHERE  op.pat_run_hn  = TO_NUMBER(:run)
        AND  op.pat_year_hn = TO_NUMBER(:year)
        AND  op.date_created >= ADD_MONTHS(TRUNC(SYSDATE), -12)
      GROUP BY op.icd_code, dm.DX_GROUP
      ORDER BY op.icd_code
    ) LOOP
      v_icd_name := r.icd_group;
      BEGIN
        SELECT icd_desc INTO v_icd_name FROM icd10s
        WHERE code = r.icd_code AND ROWNUM = 1;
      EXCEPTION WHEN OTHERS THEN v_icd_name := r.icd_group;
      END;
      APEX_JSON.open_object;
      APEX_JSON.write('icd_code',  r.icd_code);
      APEX_JSON.write('icd_group', r.icd_group);
      APEX_JSON.write('icd_name',  v_icd_name);
      APEX_JSON.write('last_date', r.last_date);
      APEX_JSON.close_object;
    END LOOP;
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
  APEX_JSON.close_array;

  APEX_JSON.open_array('drugs');
  BEGIN
    FOR r IN (
      SELECT d.CODE drug_code,
             MAX(dm.HIS_DRUG_NAME) his_drug_name,
             TO_CHAR(MAX(d.MAIN_DATE), 'YYYY-MM-DD') last_date
      FROM   data_drug_wh d
      LEFT JOIN CDSS_DRUG_MAP dm ON dm.HIS_DRUG_CODE = d.CODE AND dm.IS_ACTIVE = 'Y'
      WHERE  d.OFH_OPD_FINANCE_NO IN (
               SELECT ofh.opd_finance_no FROM OPD_FINANCE_HEADERS@pmk ofh
               WHERE  ofh.pat_run_hn  = TO_NUMBER(:run)
                 AND  ofh.pat_year_hn = TO_NUMBER(:year)
                 AND  ofh.opdipd      = 'O'
             )
        AND  d.MAIN_DATE >= ADD_MONTHS(TRUNC(SYSDATE), -12)
      GROUP BY d.CODE
      ORDER BY MAX(d.MAIN_DATE) DESC
    ) LOOP
      v_drug_name := NVL(r.his_drug_name, r.drug_code);
      IF r.his_drug_name IS NULL THEN
        BEGIN
          SELECT name INTO v_drug_name FROM drugcodes
          WHERE code = r.drug_code AND ROWNUM = 1;
        EXCEPTION WHEN OTHERS THEN v_drug_name := r.drug_code;
        END;
      END IF;
      APEX_JSON.open_object;
      APEX_JSON.write('drug_code', r.drug_code);
      APEX_JSON.write('drug_name', v_drug_name);
      APEX_JSON.write('last_date', r.last_date);
      APEX_JSON.close_object;
    END LOOP;
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
  APEX_JSON.close_array;

  APEX_JSON.close_object;
END;
]');
  COMMIT;
END;
