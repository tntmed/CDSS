-- ============================================================
-- CDSS ORDS Module v2  —  HN แยกเป็น :run/:year
-- URL pattern: /cdss/dx/:run/:year
-- ============================================================

BEGIN
  BEGIN
    ORDS.DELETE_MODULE(p_module_name => 'CDSS');
  EXCEPTION WHEN OTHERS THEN NULL;
  END;

  ORDS.DEFINE_MODULE(
    p_module_name    => 'CDSS',
    p_base_path      => '/cdss/',
    p_items_per_page => 0,
    p_status         => 'PUBLISHED'
  );

  -- 1. GET /cdss/dx/:run/:year
  ORDS.DEFINE_TEMPLATE(p_module_name => 'CDSS', p_pattern => 'dx/:run/:year');
  ORDS.DEFINE_HANDLER(
    p_module_name => 'CDSS', p_pattern => 'dx/:run/:year', p_method => 'GET',
    p_source_type => ORDS.SOURCE_TYPE_PLSQL,
    p_source => q'[
BEGIN
  APEX_JSON.open_object;
  APEX_JSON.write('hn', :run || '/' || :year);
  APEX_JSON.open_array('dx_groups');
  FOR r IN (
    SELECT DISTINCT m.DX_GROUP
    FROM   opddiags@pmk op
    JOIN   CDSS_DX_MAP m ON m.ICD_CODE = op.icd_code AND m.ACTIVE_FLAG = 'Y'
    WHERE  op.pat_run_hn  = TO_NUMBER(:run)
      AND  op.pat_year_hn = TO_NUMBER(:year)
      AND  op.date_created >= ADD_MONTHS(TRUNC(SYSDATE), -12)
    ORDER BY m.DX_GROUP
  ) LOOP
    APEX_JSON.write(r.DX_GROUP);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
END;
]');

  -- 2. GET /cdss/labs/:run/:year
  ORDS.DEFINE_TEMPLATE(p_module_name => 'CDSS', p_pattern => 'labs/:run/:year');
  ORDS.DEFINE_HANDLER(
    p_module_name => 'CDSS', p_pattern => 'labs/:run/:year', p_method => 'GET',
    p_source_type => ORDS.SOURCE_TYPE_PLSQL,
    p_source => q'[
BEGIN
  APEX_JSON.open_object;
  APEX_JSON.write('hn', :run || '/' || :year);
  APEX_JSON.open_array('labs');
  FOR r IN (
    SELECT lm.CDSS_LAB_CODE,
           TO_CHAR(MAX(lr.date_created), 'YYYY-MM-DD') AS last_date
    FROM   labresult@pmk lr
    JOIN   CDSS_LAB_MAP lm ON lm.HIS_LABCODE = lr.labcode_detail_code AND lm.IS_ACTIVE = 'Y'
    WHERE  lr.numberic_result IS NOT NULL
      AND  lr.date_created >= ADD_MONTHS(TRUNC(SYSDATE), -36)
      AND  lr.ofh_opd_finance_no IN (
             SELECT ofh.opd_finance_no
             FROM   OPD_FINANCE_HEADERS@pmk ofh
             WHERE  ofh.pat_run_hn  = TO_NUMBER(:run)
               AND  ofh.pat_year_hn = TO_NUMBER(:year)
               AND  ofh.opdipd = 'O'
           )
    GROUP BY lm.CDSS_LAB_CODE ORDER BY lm.CDSS_LAB_CODE
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('lab_code',  r.CDSS_LAB_CODE);
    APEX_JSON.write('last_date', r.last_date);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
END;
]');

  -- 3. GET /cdss/patient/:run/:year
  ORDS.DEFINE_TEMPLATE(p_module_name => 'CDSS', p_pattern => 'patient/:run/:year');
  ORDS.DEFINE_HANDLER(
    p_module_name => 'CDSS', p_pattern => 'patient/:run/:year', p_method => 'GET',
    p_source_type => ORDS.SOURCE_TYPE_PLSQL,
    p_source => q'[
DECLARE
  l_name VARCHAR2(300);
BEGIN
  BEGIN
    SELECT TRIM(pname || ' ' || fname || ' ' || lname)
    INTO   l_name
    FROM   patients@pmk
    WHERE  pat_run_hn = TO_NUMBER(:run) AND pat_year_hn = TO_NUMBER(:year)
      AND  ROWNUM = 1;
  EXCEPTION WHEN OTHERS THEN l_name := NULL;
  END;
  APEX_JSON.open_object;
  APEX_JSON.write('hn',           :run || '/' || :year);
  APEX_JSON.write('patient_name', l_name);
  APEX_JSON.close_object;
END;
]');

  -- 4. GET /cdss/rules
  ORDS.DEFINE_TEMPLATE(p_module_name => 'CDSS', p_pattern => 'rules');
  ORDS.DEFINE_HANDLER(
    p_module_name => 'CDSS', p_pattern => 'rules', p_method => 'GET',
    p_source_type => ORDS.SOURCE_TYPE_PLSQL,
    p_source => q'[
BEGIN
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT r.RULE_CODE, r.RULE_NAME, r.DISEASE_GROUP_CODE,
           r.LAB_CODE, m.CDSS_LAB_NAME, r.CHECK_EVERY_DAYS
    FROM   CDSS_RULE_LAB r
    JOIN   CDSS_LAB_MASTER m ON m.CDSS_LAB_CODE = r.LAB_CODE
    WHERE  r.IS_ACTIVE = 'Y'
    ORDER  BY r.DISEASE_GROUP_CODE, r.PRIORITY_SEQ
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('rule_code',          r.RULE_CODE);
    APEX_JSON.write('rule_name',          r.RULE_NAME);
    APEX_JSON.write('disease_group_code', r.DISEASE_GROUP_CODE);
    APEX_JSON.write('lab_code',           r.LAB_CODE);
    APEX_JSON.write('lab_name',           r.CDSS_LAB_NAME);
    APEX_JSON.write('check_every_days',   r.CHECK_EVERY_DAYS);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
END;
]');

  -- 5. GET /cdss/labs_master
  ORDS.DEFINE_TEMPLATE(p_module_name => 'CDSS', p_pattern => 'labs_master');
  ORDS.DEFINE_HANDLER(
    p_module_name => 'CDSS', p_pattern => 'labs_master', p_method => 'GET',
    p_source_type => ORDS.SOURCE_TYPE_PLSQL,
    p_source => q'[
BEGIN
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT CDSS_LAB_CODE, CDSS_LAB_NAME, LAB_GROUP
    FROM   CDSS_LAB_MASTER
    WHERE  IS_ACTIVE = 'Y'
    ORDER  BY LAB_GROUP, CDSS_LAB_CODE
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code',  r.CDSS_LAB_CODE);
    APEX_JSON.write('name',  r.CDSS_LAB_NAME);
    APEX_JSON.write('group', r.LAB_GROUP);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
END;
]');

  COMMIT;
END;
