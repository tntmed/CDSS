BEGIN
  -- 1. เพิ่ม CDSS_LAB_MASTER ที่ยังไม่มี
  MERGE INTO CDSS_LAB_MASTER m
  USING (
    SELECT 'TOTAL_CHOL' CDSS_LAB_CODE, 'Total Cholesterol' CDSS_LAB_NAME, 'LIPID'      LAB_GROUP FROM DUAL UNION ALL
    SELECT 'HDL_CHOL',  'HDL Cholesterol',                  'LIPID'                              FROM DUAL UNION ALL
    SELECT 'LDL_CHOL',  'LDL Cholesterol',                  'LIPID'                              FROM DUAL UNION ALL
    SELECT 'TG',        'Triglyceride',                     'LIPID'                              FROM DUAL UNION ALL
    SELECT 'HBA1C',     'HbA1c',                            'CHEMISTRY'                          FROM DUAL UNION ALL
    SELECT 'CK',        'Creatine Kinase',                  'MUSCLE'                             FROM DUAL UNION ALL
    SELECT 'VIT_B12',   'Vitamin B12',                      'NUTRITION'                          FROM DUAL
  ) s ON (m.CDSS_LAB_CODE = s.CDSS_LAB_CODE)
  WHEN NOT MATCHED THEN
    INSERT (CDSS_LAB_CODE, CDSS_LAB_NAME, LAB_GROUP, UNIT_TEXT, IS_ACTIVE, CREATED_AT, CREATED_BY)
    VALUES (s.CDSS_LAB_CODE, s.CDSS_LAB_NAME, s.LAB_GROUP, '-', 'Y', SYSDATE, 'SEED');

  -- 2. เพิ่ม CDSS_LAB_MAP
  MERGE INTO CDSS_LAB_MAP tgt
  USING (
    SELECT 'BI022-06' HIS_LABCODE, 'Sodium'          HIS_LABNAME, 'ELECTROLYTE' HIS_GROUP_CODE, 'NA'          CDSS_LAB_CODE FROM DUAL UNION ALL
    SELECT 'BI022-07', 'Potassium',                   'ELECTROLYTE',             'K'                                         FROM DUAL UNION ALL
    SELECT 'BI003-02', 'Creatinine',                  'RENAL',                   'CREATININE'                                FROM DUAL UNION ALL
    SELECT 'BI003-03', 'eGFR',                        'RENAL',                   'CREATININE'                                FROM DUAL UNION ALL
    SELECT 'BI002-02', 'BUN',                         'RENAL',                   'BUN'                                       FROM DUAL UNION ALL
    SELECT 'HE001-03', 'WBC',                         'HEMATOLOGY',              'CBC'                                       FROM DUAL UNION ALL
    SELECT 'HE001-01', 'Hemoglobin',                  'HEMATOLOGY',              'CBC'                                       FROM DUAL UNION ALL
    SELECT 'HE001-02', 'Hematocrit',                  'HEMATOLOGY',              'CBC'                                       FROM DUAL UNION ALL
    SELECT 'HE001-15', 'Platelet count',              'HEMATOLOGY',              'PLATELET'                                  FROM DUAL UNION ALL
    SELECT 'BI001-02', 'FBS',                         'CHEMISTRY',               'GLUCOSE'                                   FROM DUAL UNION ALL
    SELECT 'BI046-02', 'FPG',                         'CHEMISTRY',               'GLUCOSE'                                   FROM DUAL UNION ALL
    SELECT 'BI037-01', 'HbA1c',                       'CHEMISTRY',               'HBA1C'                                     FROM DUAL UNION ALL
    SELECT 'BI015-01', 'AST',                         'LIVER',                   'AST'                                       FROM DUAL UNION ALL
    SELECT 'BI016-01', 'ALT',                         'LIVER',                   'ALT'                                       FROM DUAL UNION ALL
    SELECT 'BI006-01', 'Cholesterol',                 'LIPID',                   'TOTAL_CHOL'                                FROM DUAL UNION ALL
    SELECT 'BI007-01', 'Triglycerides',               'LIPID',                   'TG'                                        FROM DUAL UNION ALL
    SELECT 'BI008-01', 'HDL-C',                       'LIPID',                   'HDL_CHOL'                                  FROM DUAL UNION ALL
    SELECT 'BI205-01', 'LDL-C(DIRECT)',               'LIPID',                   'LDL_CHOL'                                  FROM DUAL UNION ALL
    SELECT 'SA203-01', 'TSH',                         'ENDOCRINE',               'TSH'                                       FROM DUAL UNION ALL
    SELECT 'SA204-01', 'FT4',                         'ENDOCRINE',               'FREE_T4'                                   FROM DUAL UNION ALL
    SELECT 'SA212-01', 'FT3',                         'ENDOCRINE',               'FREE_T4'                                   FROM DUAL UNION ALL
    SELECT 'BI020-01', 'CPK',                         'MUSCLE',                  'CK'                                        FROM DUAL UNION ALL
    SELECT 'BI230-01', 'VITAMIN B12',                 'NUTRITION',               'VIT_B12'                                   FROM DUAL
  ) src ON (tgt.HIS_LABCODE = src.HIS_LABCODE AND tgt.CDSS_LAB_CODE = src.CDSS_LAB_CODE)
  WHEN NOT MATCHED THEN
    INSERT (HIS_LABCODE, HIS_LABNAME, HIS_GROUP_CODE, CDSS_LAB_CODE, MATCH_SOURCE, IS_ACTIVE, CREATED_AT)
    VALUES (src.HIS_LABCODE, src.HIS_LABNAME, src.HIS_GROUP_CODE, src.CDSS_LAB_CODE, 'AUTO', 'Y', SYSDATE);

  COMMIT;
END;
