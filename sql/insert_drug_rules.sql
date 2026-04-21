BEGIN
  -- เพิ่ม BICARB ใน CDSS_LAB_MASTER (สำหรับ Topiramate)
  MERGE INTO CDSS_LAB_MASTER m
  USING (SELECT 'BICARB' CDSS_LAB_CODE,'Bicarbonate' CDSS_LAB_NAME,'CHEMISTRY' LAB_GROUP FROM DUAL) s
  ON (m.CDSS_LAB_CODE = s.CDSS_LAB_CODE)
  WHEN NOT MATCHED THEN
    INSERT (CDSS_LAB_CODE,CDSS_LAB_NAME,LAB_GROUP,UNIT_TEXT,IS_ACTIVE,CREATED_AT,CREATED_BY)
    VALUES (s.CDSS_LAB_CODE,s.CDSS_LAB_NAME,s.LAB_GROUP,'-','Y',SYSDATE,'SEED');

  -- เพิ่ม BICARB mapping (HIS code BI022-09)
  MERGE INTO CDSS_LAB_MAP tgt
  USING (SELECT 'BI022-09' HIS_LABCODE,'Bicarbonate' HIS_LABNAME,'CHEMISTRY' HIS_GROUP_CODE,'BICARB' CDSS_LAB_CODE FROM DUAL) src
  ON (tgt.HIS_LABCODE = src.HIS_LABCODE AND tgt.CDSS_LAB_CODE = src.CDSS_LAB_CODE)
  WHEN NOT MATCHED THEN
    INSERT (HIS_LABCODE,HIS_LABNAME,HIS_GROUP_CODE,CDSS_LAB_CODE,MATCH_SOURCE,IS_ACTIVE,CREATED_AT)
    VALUES (src.HIS_LABCODE,src.HIS_LABNAME,src.HIS_GROUP_CODE,src.CDSS_LAB_CODE,'AUTO','Y',SYSDATE);

  -- เพิ่ม AED Rules ใน CDSS_RULE_LAB
  INSERT INTO CDSS_RULE_LAB
    (RULE_ID,RULE_CODE,RULE_NAME,DISEASE_GROUP_CODE,DRUG_GROUP_CODE,LAB_CODE,RULE_SCOPE,CHECK_EVERY_DAYS,IS_ACTIVE,PRIORITY_SEQ)
  SELECT
    (SELECT NVL(MAX(RULE_ID),0) FROM CDSS_RULE_LAB) + ROWNUM,
    s.RULE_CODE,s.RULE_NAME,'-',s.DRUG,s.LAB,'DRUG_ONLY',s.DAYS,'Y',s.SEQ
  FROM (
    SELECT 'CBZ_CBC'  RULE_CODE,'Carbamazepine - CBC'                RULE_NAME,'Carbamazepine'  DRUG,'CBC'        LAB, 90 DAYS,10 SEQ FROM DUAL UNION ALL
    SELECT 'CBZ_NA',  'Carbamazepine - Sodium',                      'Carbamazepine','NA',                        60,10 FROM DUAL UNION ALL
    SELECT 'CBZ_AST', 'Carbamazepine - AST',                         'Carbamazepine','AST',                      180,20 FROM DUAL UNION ALL
    SELECT 'CBZ_ALT', 'Carbamazepine - ALT',                         'Carbamazepine','ALT',                      180,20 FROM DUAL UNION ALL
    SELECT 'OXC_NA',  'Oxcarbazepine - Sodium',                      'Oxcarbazepine','NA',                        60,10 FROM DUAL UNION ALL
    SELECT 'OXC_CBC', 'Oxcarbazepine - CBC',                         'Oxcarbazepine','CBC',                      180,20 FROM DUAL UNION ALL
    SELECT 'VPA_CBC', 'Valproate - CBC',                             'Valproate',    'CBC',                       90,10 FROM DUAL UNION ALL
    SELECT 'VPA_PLT', 'Valproate - Platelet',                        'Valproate',    'PLATELET',                  90,10 FROM DUAL UNION ALL
    SELECT 'VPA_AST', 'Valproate - AST',                             'Valproate',    'AST',                       90,10 FROM DUAL UNION ALL
    SELECT 'VPA_ALT', 'Valproate - ALT',                             'Valproate',    'ALT',                       90,10 FROM DUAL UNION ALL
    SELECT 'VPA_INR', 'Valproate - PT/INR',                          'Valproate',    'PT_INR',                   180,20 FROM DUAL UNION ALL
    SELECT 'PHT_CBC', 'Phenytoin - CBC',                             'Phenytoin',    'CBC',                      180,10 FROM DUAL UNION ALL
    SELECT 'PHT_AST', 'Phenytoin - AST',                             'Phenytoin',    'AST',                      180,10 FROM DUAL UNION ALL
    SELECT 'PHT_ALT', 'Phenytoin - ALT',                             'Phenytoin',    'ALT',                      180,10 FROM DUAL UNION ALL
    SELECT 'PHT_GLUC','Phenytoin - Glucose',                         'Phenytoin',    'GLUCOSE',                  180,20 FROM DUAL UNION ALL
    SELECT 'PB_CBC',  'Phenobarbital - CBC',                         'Phenobarbital','CBC',                      180,10 FROM DUAL UNION ALL
    SELECT 'PB_AST',  'Phenobarbital - AST',                         'Phenobarbital','AST',                      180,10 FROM DUAL UNION ALL
    SELECT 'PB_ALT',  'Phenobarbital - ALT',                         'Phenobarbital','ALT',                      180,10 FROM DUAL UNION ALL
    SELECT 'LEV_CRE', 'Levetiracetam - Creatinine',                  'Levetiracetam','CREATININE',               180,10 FROM DUAL UNION ALL
    SELECT 'LEV_CBC', 'Levetiracetam - CBC',                         'Levetiracetam','CBC',                      365,20 FROM DUAL UNION ALL
    SELECT 'LTG_CBC', 'Lamotrigine - CBC',                           'Lamotrigine',  'CBC',                      180,10 FROM DUAL UNION ALL
    SELECT 'LTG_AST', 'Lamotrigine - AST',                           'Lamotrigine',  'AST',                      180,10 FROM DUAL UNION ALL
    SELECT 'LTG_ALT', 'Lamotrigine - ALT',                           'Lamotrigine',  'ALT',                      180,10 FROM DUAL UNION ALL
    SELECT 'TPM_CRE', 'Topiramate - Creatinine',                     'Topiramate',   'CREATININE',               180,10 FROM DUAL UNION ALL
    SELECT 'TPM_BIC', 'Topiramate - Bicarbonate',                    'Topiramate',   'BICARB',                   180,10 FROM DUAL UNION ALL
    SELECT 'PGB_CRE', 'Pregabalin - Creatinine',                     'Pregabalin',   'CREATININE',               180,10 FROM DUAL UNION ALL
    SELECT 'GBP_CRE', 'Gabapentin - Creatinine',                     'Gabapentin',   'CREATININE',               180,10 FROM DUAL
  ) s
  WHERE NOT EXISTS (SELECT 1 FROM CDSS_RULE_LAB r WHERE r.RULE_CODE = s.RULE_CODE);

  COMMIT;
END;
