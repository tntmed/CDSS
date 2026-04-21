BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name => 'CDSS', p_pattern => 'drugs/:run/:year');
  ORDS.DEFINE_HANDLER(
    p_module_name => 'CDSS', p_pattern => 'drugs/:run/:year', p_method => 'GET',
    p_source_type => 'plsql/block',
    p_source => q'[
BEGIN
  APEX_JSON.open_object;
  APEX_JSON.write('hn', :run || '/' || :year);
  APEX_JSON.open_array('drug_groups');
  FOR r IN (
    SELECT DISTINCT dm.DRUG_GROUP
    FROM   data_drug_wh      d
    JOIN   CDSS_DRUG_MAP      dm ON dm.HIS_DRUG_CODE = d.CODE AND dm.IS_ACTIVE = 'Y'
    WHERE  d.OFH_OPD_FINANCE_NO IN (
             SELECT ofh.opd_finance_no
             FROM   OPD_FINANCE_HEADERS@pmk ofh
             WHERE  ofh.pat_run_hn  = TO_NUMBER(:run)
               AND  ofh.pat_year_hn = TO_NUMBER(:year)
               AND  ofh.opdipd      = 'O'
           )
      AND  d.MAIN_DATE >= ADD_MONTHS(TRUNC(SYSDATE), -3)
    ORDER BY dm.DRUG_GROUP
  ) LOOP
    APEX_JSON.write(r.DRUG_GROUP);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
END;
]');
  COMMIT;
END;
