BEGIN

  -- ============================================================
  -- 1. CDSS_DX_MAP: ICD-10 codes สำหรับ DM
  -- ============================================================
  MERGE INTO CDSS_DX_MAP t
  USING (
    SELECT 'E10'  ICD_CODE,'DM' DX_GROUP,'Y' FLAG FROM DUAL UNION ALL
    SELECT 'E100','DM','Y' FROM DUAL UNION ALL SELECT 'E101','DM','Y' FROM DUAL UNION ALL
    SELECT 'E102','DM','Y' FROM DUAL UNION ALL SELECT 'E103','DM','Y' FROM DUAL UNION ALL
    SELECT 'E104','DM','Y' FROM DUAL UNION ALL SELECT 'E105','DM','Y' FROM DUAL UNION ALL
    SELECT 'E106','DM','Y' FROM DUAL UNION ALL SELECT 'E107','DM','Y' FROM DUAL UNION ALL
    SELECT 'E108','DM','Y' FROM DUAL UNION ALL SELECT 'E109','DM','Y' FROM DUAL UNION ALL
    SELECT 'E11', 'DM','Y' FROM DUAL UNION ALL
    SELECT 'E110','DM','Y' FROM DUAL UNION ALL SELECT 'E111','DM','Y' FROM DUAL UNION ALL
    SELECT 'E112','DM','Y' FROM DUAL UNION ALL SELECT 'E113','DM','Y' FROM DUAL UNION ALL
    SELECT 'E114','DM','Y' FROM DUAL UNION ALL SELECT 'E115','DM','Y' FROM DUAL UNION ALL
    SELECT 'E116','DM','Y' FROM DUAL UNION ALL SELECT 'E117','DM','Y' FROM DUAL UNION ALL
    SELECT 'E118','DM','Y' FROM DUAL UNION ALL SELECT 'E119','DM','Y' FROM DUAL UNION ALL
    SELECT 'E12', 'DM','Y' FROM DUAL UNION ALL SELECT 'E120','DM','Y' FROM DUAL UNION ALL
    SELECT 'E121','DM','Y' FROM DUAL UNION ALL SELECT 'E122','DM','Y' FROM DUAL UNION ALL
    SELECT 'E123','DM','Y' FROM DUAL UNION ALL SELECT 'E124','DM','Y' FROM DUAL UNION ALL
    SELECT 'E125','DM','Y' FROM DUAL UNION ALL SELECT 'E126','DM','Y' FROM DUAL UNION ALL
    SELECT 'E127','DM','Y' FROM DUAL UNION ALL SELECT 'E128','DM','Y' FROM DUAL UNION ALL
    SELECT 'E129','DM','Y' FROM DUAL UNION ALL
    SELECT 'E13', 'DM','Y' FROM DUAL UNION ALL SELECT 'E130','DM','Y' FROM DUAL UNION ALL
    SELECT 'E131','DM','Y' FROM DUAL UNION ALL SELECT 'E132','DM','Y' FROM DUAL UNION ALL
    SELECT 'E133','DM','Y' FROM DUAL UNION ALL SELECT 'E134','DM','Y' FROM DUAL UNION ALL
    SELECT 'E135','DM','Y' FROM DUAL UNION ALL SELECT 'E136','DM','Y' FROM DUAL UNION ALL
    SELECT 'E137','DM','Y' FROM DUAL UNION ALL SELECT 'E138','DM','Y' FROM DUAL UNION ALL
    SELECT 'E139','DM','Y' FROM DUAL UNION ALL
    SELECT 'E14', 'DM','Y' FROM DUAL UNION ALL SELECT 'E140','DM','Y' FROM DUAL UNION ALL
    SELECT 'E141','DM','Y' FROM DUAL UNION ALL SELECT 'E142','DM','Y' FROM DUAL UNION ALL
    SELECT 'E143','DM','Y' FROM DUAL UNION ALL SELECT 'E144','DM','Y' FROM DUAL UNION ALL
    SELECT 'E145','DM','Y' FROM DUAL UNION ALL SELECT 'E146','DM','Y' FROM DUAL UNION ALL
    SELECT 'E147','DM','Y' FROM DUAL UNION ALL SELECT 'E148','DM','Y' FROM DUAL UNION ALL
    SELECT 'E149','DM','Y' FROM DUAL
  ) s ON (t.ICD_CODE = s.ICD_CODE)
  WHEN NOT MATCHED THEN
    INSERT (ICD_CODE, DX_GROUP, ACTIVE_FLAG) VALUES (s.ICD_CODE, s.DX_GROUP, s.FLAG);

  -- ============================================================
  -- 2. CDSS_LAB_MASTER: เพิ่ม lab ที่ยังขาด
  -- ============================================================
  MERGE INTO CDSS_LAB_MASTER m
  USING (
    SELECT 'UACR'    CDSS_LAB_CODE,'Urine Albumin-Creatinine Ratio' CDSS_LAB_NAME,'URINE'     LAB_GROUP,'mg/g'  UNIT FROM DUAL UNION ALL
    SELECT 'K',       'Potassium',                                    'CHEMISTRY',              'mEq/L'        FROM DUAL UNION ALL
    SELECT 'GLUCOSE', 'Fasting Blood Sugar',                          'CHEMISTRY',              'mg/dL'        FROM DUAL
  ) s ON (m.CDSS_LAB_CODE = s.CDSS_LAB_CODE)
  WHEN NOT MATCHED THEN
    INSERT (CDSS_LAB_CODE,CDSS_LAB_NAME,LAB_GROUP,UNIT_TEXT,IS_ACTIVE,CREATED_AT,CREATED_BY)
    VALUES (s.CDSS_LAB_CODE,s.CDSS_LAB_NAME,s.LAB_GROUP,s.UNIT,'Y',SYSDATE,'SEED');

  -- ============================================================
  -- 3. CDSS_LAB_MAP: map HIS lab codes → CDSS codes
  --    *** ตรวจสอบ HIS_LABCODE ให้ตรงกับระบบของโรงพยาบาล ***
  -- ============================================================
  MERGE INTO CDSS_LAB_MAP tgt
  USING (
    SELECT 'BI032-01' HIS_LABCODE,'Potassium'  HIS_LABNAME,'CHEMISTRY' GRP,'K'       CDSS FROM DUAL UNION ALL
    SELECT 'BI001-01','FBS',                    'CHEMISTRY',              'GLUCOSE'        FROM DUAL UNION ALL
    SELECT 'BI001-02','Blood Sugar',             'CHEMISTRY',              'GLUCOSE'        FROM DUAL UNION ALL
    SELECT 'UR055-01','Urine ACR',               'URINE',                  'UACR'           FROM DUAL
  ) s ON (tgt.HIS_LABCODE = s.HIS_LABCODE AND tgt.CDSS_LAB_CODE = s.CDSS)
  WHEN NOT MATCHED THEN
    INSERT (HIS_LABCODE,HIS_LABNAME,HIS_GROUP_CODE,CDSS_LAB_CODE,MATCH_SOURCE,IS_ACTIVE,CREATED_AT)
    VALUES (s.HIS_LABCODE,s.HIS_LABNAME,s.GRP,s.CDSS,'MANUAL','Y',SYSDATE);

  -- ============================================================
  -- 4. CDSS_DRUG_MAP: DM drug groups
  --    *** เพิ่ม HIS drug codes จริงของโรงพยาบาลด้านล่าง ***
  -- ============================================================
  MERGE INTO CDSS_DRUG_MAP tgt
  USING (
    SELECT 'MET500E' HIS_DRUG_CODE,'Metformin 500mg'     HIS_DRUG_NAME,'METFORMIN' DRUG_GROUP FROM DUAL UNION ALL
    SELECT 'MET850E','Metformin 850mg',                   'METFORMIN'                          FROM DUAL UNION ALL
    SELECT 'MET1000E','Metformin 1000mg',                 'METFORMIN'                          FROM DUAL UNION ALL
    SELECT 'INS101E','Insulin Regular',                   'INSULIN'                            FROM DUAL UNION ALL
    SELECT 'INS102E','Insulin NPH',                       'INSULIN'                            FROM DUAL UNION ALL
    SELECT 'INS103E','Insulin Glargine',                  'INSULIN'                            FROM DUAL UNION ALL
    SELECT 'ENA5E', 'Enalapril 5mg',                      'ACEI_ARB'                           FROM DUAL UNION ALL
    SELECT 'ENA10E','Enalapril 10mg',                     'ACEI_ARB'                           FROM DUAL UNION ALL
    SELECT 'LOS50E','Losartan 50mg',                      'ACEI_ARB'                           FROM DUAL UNION ALL
    SELECT 'LOS100E','Losartan 100mg',                    'ACEI_ARB'                           FROM DUAL UNION ALL
    SELECT 'VLS80E','Valsartan 80mg',                     'ACEI_ARB'                           FROM DUAL UNION ALL
    SELECT 'RAM5E', 'Ramipril 5mg',                       'ACEI_ARB'                           FROM DUAL
  ) s ON (tgt.HIS_DRUG_CODE = s.HIS_DRUG_CODE)
  WHEN NOT MATCHED THEN
    INSERT (HIS_DRUG_CODE,HIS_DRUG_NAME,DRUG_GROUP,IS_ACTIVE,CREATED_AT,CREATED_BY)
    VALUES (s.HIS_DRUG_CODE,s.HIS_DRUG_NAME,s.DRUG_GROUP,'Y',SYSDATE,'SEED');

  -- ============================================================
  -- 5. CDSS_RULE_LAB: DM rules
  -- ============================================================
  INSERT INTO CDSS_RULE_LAB
    (RULE_ID,RULE_CODE,RULE_NAME,DISEASE_GROUP_CODE,DRUG_GROUP_CODE,LAB_CODE,RULE_SCOPE,CHECK_EVERY_DAYS,IS_ACTIVE,PRIORITY_SEQ)
  SELECT
    (SELECT NVL(MAX(RULE_ID),0) FROM CDSS_RULE_LAB) + ROWNUM,
    s.RULE_CODE,s.RULE_NAME,s.DX,s.DRUG,s.LAB,s.SCOPE,s.DAYS,'Y',s.SEQ
  FROM (
    -- Disease-only: core DM monitoring
    SELECT 'DM_HBA1C' RULE_CODE,'DM - HbA1c'                 RULE_NAME,'DM' DX,'-' DRUG,'HBA1C'      LAB,'DISEASE_ONLY' SCOPE, 90 DAYS,10 SEQ FROM DUAL UNION ALL
    SELECT 'DM_FBS',  'DM - Fasting Blood Sugar',             'DM','-','GLUCOSE',    'DISEASE_ONLY',  90,10 FROM DUAL UNION ALL
    SELECT 'DM_CRE',  'DM - Creatinine',                      'DM','-','CREATININE', 'DISEASE_ONLY', 180,10 FROM DUAL UNION ALL
    SELECT 'DM_LDL',  'DM - LDL Cholesterol',                 'DM','-','LDL_CHOL',  'DISEASE_ONLY', 180,20 FROM DUAL UNION ALL
    SELECT 'DM_TG',   'DM - Triglyceride',                    'DM','-','TG',         'DISEASE_ONLY', 180,20 FROM DUAL UNION ALL
    SELECT 'DM_HDL',  'DM - HDL Cholesterol',                 'DM','-','HDL_CHOL',  'DISEASE_ONLY', 365,20 FROM DUAL UNION ALL
    SELECT 'DM_TC',   'DM - Total Cholesterol',               'DM','-','TOTAL_CHOL','DISEASE_ONLY', 365,20 FROM DUAL UNION ALL
    SELECT 'DM_UACR', 'DM - Urine ACR',                       'DM','-','UACR',       'DISEASE_ONLY', 365,10 FROM DUAL UNION ALL
    SELECT 'DM_K',    'DM - Potassium',                       'DM','-','K',          'DISEASE_ONLY', 180,20 FROM DUAL UNION ALL
    SELECT 'DM_CBC',  'DM - CBC',                             'DM','-','CBC',        'DISEASE_ONLY', 180,30 FROM DUAL UNION ALL
    -- Drug-only: Metformin → renal monitoring
    SELECT 'MET_CRE', 'Metformin - Creatinine',               '-','METFORMIN','CREATININE','DRUG_ONLY',180,10 FROM DUAL UNION ALL
    SELECT 'MET_K',   'Metformin - Potassium',                '-','METFORMIN','K',          'DRUG_ONLY',180,20 FROM DUAL UNION ALL
    -- Drug-only: Insulin → glucose monitoring
    SELECT 'INS_FBS', 'Insulin - Fasting Blood Sugar',        '-','INSULIN',  'GLUCOSE',   'DRUG_ONLY', 90,10 FROM DUAL UNION ALL
    SELECT 'INS_HBA', 'Insulin - HbA1c',                      '-','INSULIN',  'HBA1C',     'DRUG_ONLY', 90,10 FROM DUAL UNION ALL
    -- Drug-only: ACEI/ARB → K+ and renal monitoring
    SELECT 'ACE_K',   'ACEI/ARB - Potassium',                 '-','ACEI_ARB', 'K',         'DRUG_ONLY', 90,10 FROM DUAL UNION ALL
    SELECT 'ACE_CRE', 'ACEI/ARB - Creatinine',                '-','ACEI_ARB', 'CREATININE','DRUG_ONLY', 90,10 FROM DUAL
  ) s
  WHERE NOT EXISTS (SELECT 1 FROM CDSS_RULE_LAB r WHERE r.RULE_CODE = s.RULE_CODE);

  COMMIT;
END;
