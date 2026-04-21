BEGIN
  ORDS.DEFINE_HANDLER(
    p_module_name => 'CDSS', p_pattern => 'rules', p_method => 'GET',
    p_source_type => 'plsql/block',
    p_source => q'[
BEGIN
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT r.RULE_CODE, r.RULE_NAME, r.DISEASE_GROUP_CODE, r.DRUG_GROUP_CODE,
           r.LAB_CODE, m.CDSS_LAB_NAME, r.CHECK_EVERY_DAYS, r.RULE_SCOPE
    FROM   CDSS_RULE_LAB r
    JOIN   CDSS_LAB_MASTER m ON m.CDSS_LAB_CODE = r.LAB_CODE
    WHERE  r.IS_ACTIVE = 'Y'
    ORDER  BY r.RULE_SCOPE, r.DISEASE_GROUP_CODE, r.DRUG_GROUP_CODE, r.PRIORITY_SEQ
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('rule_code',          r.RULE_CODE);
    APEX_JSON.write('rule_name',          r.RULE_NAME);
    APEX_JSON.write('disease_group_code', r.DISEASE_GROUP_CODE);
    APEX_JSON.write('drug_group_code',    r.DRUG_GROUP_CODE);
    APEX_JSON.write('lab_code',           r.LAB_CODE);
    APEX_JSON.write('lab_name',           r.CDSS_LAB_NAME);
    APEX_JSON.write('check_every_days',   r.CHECK_EVERY_DAYS);
    APEX_JSON.write('rule_scope',         r.RULE_SCOPE);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
END;
]');
  COMMIT;
END;
