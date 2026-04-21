BEGIN
  INSERT INTO CDSS_RULE_LAB
    (RULE_CODE, RULE_NAME, DISEASE_GROUP_CODE, DRUG_GROUP_CODE, LAB_CODE, RULE_SCOPE, CHECK_EVERY_DAYS, IS_ACTIVE, PRIORITY_SEQ)
  SELECT
    (SELECT NVL(MAX(RULE_ID),0) FROM CDSS_RULE_LAB) + ROWNUM,
    s.RULE_CODE, s.RULE_NAME, s.DX, s.DRUG, s.LAB, s.SCOPE, s.DAYS, 'Y', s.SEQ
  FROM (
    SELECT 'DLP_LDL'      RULE_CODE,'Dyslipidemia monitoring - LDL'            RULE_NAME,'Dyslipidemia' DX,'-' DRUG,'LDL_CHOL'   LAB,'DISEASE_ONLY' SCOPE, 90 DAYS,10 SEQ FROM DUAL UNION ALL
    SELECT 'DLP_TC',      'Dyslipidemia monitoring - Total Cholesterol',       'Dyslipidemia','-','TOTAL_CHOL', 'DISEASE_ONLY', 90,10 FROM DUAL UNION ALL
    SELECT 'DLP_TG',      'Dyslipidemia monitoring - Triglyceride',            'Dyslipidemia','-','TG',         'DISEASE_ONLY', 90,10 FROM DUAL UNION ALL
    SELECT 'DLP_HDL',     'Dyslipidemia monitoring - HDL',                    'Dyslipidemia','-','HDL_CHOL',   'DISEASE_ONLY', 90,10 FROM DUAL UNION ALL
    SELECT 'DLP_CK',      'Dyslipidemia monitoring - CK',                     'Dyslipidemia','-','CK',         'DISEASE_ONLY', 90,20 FROM DUAL UNION ALL
    SELECT 'DLP_CRE',     'Dyslipidemia monitoring - Creatinine',             'Dyslipidemia','-','CREATININE', 'DISEASE_ONLY', 90,20 FROM DUAL UNION ALL
    SELECT 'HT_NA',       'Hypertension monitoring - Sodium',                 'Hypertension', '-','NA',         'DISEASE_ONLY', 90,10 FROM DUAL UNION ALL
    SELECT 'HT_K',        'Hypertension monitoring - Potassium',              'Hypertension', '-','K',          'DISEASE_ONLY', 90,10 FROM DUAL UNION ALL
    SELECT 'HT_GLUC',     'Hypertension monitoring - Glucose',                'Hypertension', '-','GLUCOSE',    'DISEASE_ONLY',180,20 FROM DUAL UNION ALL
    SELECT 'HT_LDL',      'Hypertension monitoring - LDL',                    'Hypertension', '-','LDL_CHOL',  'DISEASE_ONLY',180,20 FROM DUAL UNION ALL
    SELECT 'STROKE_INR',  'Stroke monitoring - PT/INR',                       'Stroke',       '-','PT_INR',     'DISEASE_ONLY', 30,10 FROM DUAL UNION ALL
    SELECT 'STROKE_NA',   'Stroke monitoring - Sodium',                       'Stroke',       '-','NA',         'DISEASE_ONLY', 90,10 FROM DUAL UNION ALL
    SELECT 'STROKE_K',    'Stroke monitoring - Potassium',                    'Stroke',       '-','K',          'DISEASE_ONLY', 90,10 FROM DUAL UNION ALL
    SELECT 'STROKE_GLUC', 'Stroke monitoring - Glucose',                      'Stroke',       '-','GLUCOSE',    'DISEASE_ONLY', 90,10 FROM DUAL UNION ALL
    SELECT 'STROKE_LDL',  'Stroke monitoring - LDL',                          'Stroke',       '-','LDL_CHOL',  'DISEASE_ONLY',180,20 FROM DUAL UNION ALL
    SELECT 'STROKE_HBA1C','Stroke monitoring - HbA1c',                        'Stroke',       '-','HBA1C',     'DISEASE_ONLY',180,20 FROM DUAL UNION ALL
    SELECT 'MEN_CBC',     'Meningioma monitoring - CBC',                      'Meningioma',   '-','CBC',        'DISEASE_ONLY', 90,10 FROM DUAL UNION ALL
    SELECT 'MEN_NA',      'Meningioma monitoring - Sodium',                   'Meningioma',   '-','NA',         'DISEASE_ONLY', 30,10 FROM DUAL UNION ALL
    SELECT 'MEN_CRE',     'Meningioma monitoring - Creatinine',               'Meningioma',   '-','CREATININE', 'DISEASE_ONLY',180,20 FROM DUAL UNION ALL
    SELECT 'GBM_CBC',     'GBM monitoring - CBC',                             'GBM',          '-','CBC',        'DISEASE_ONLY', 14,10 FROM DUAL UNION ALL
    SELECT 'GBM_AST',     'GBM monitoring - AST',                             'GBM',          '-','AST',        'DISEASE_ONLY', 30,10 FROM DUAL UNION ALL
    SELECT 'GBM_ALT',     'GBM monitoring - ALT',                             'GBM',          '-','ALT',        'DISEASE_ONLY', 30,10 FROM DUAL UNION ALL
    SELECT 'GBM_NA',      'GBM monitoring - Sodium',                          'GBM',          '-','NA',         'DISEASE_ONLY', 14,10 FROM DUAL UNION ALL
    SELECT 'GBM_GLUC',    'GBM monitoring - Glucose',                         'GBM',          '-','GLUCOSE',    'DISEASE_ONLY', 30,10 FROM DUAL UNION ALL
    SELECT 'GBM_CRE',     'GBM monitoring - Creatinine',                      'GBM',          '-','CREATININE', 'DISEASE_ONLY', 90,20 FROM DUAL UNION ALL
    SELECT 'ABSCESS_CBC', 'Brain abscess monitoring - CBC',                   'Brain abscess','-','CBC',        'DISEASE_ONLY', 14,10 FROM DUAL UNION ALL
    SELECT 'ABSCESS_CRE', 'Brain abscess monitoring - Creatinine',            'Brain abscess','-','CREATININE', 'DISEASE_ONLY', 30,20 FROM DUAL UNION ALL
    SELECT 'NPH_NA',      'NPH monitoring - Sodium',                          'NPH',          '-','NA',         'DISEASE_ONLY', 30,10 FROM DUAL UNION ALL
    SELECT 'NPH_CBC',     'NPH monitoring - CBC',                             'NPH',          '-','CBC',        'DISEASE_ONLY', 90,10 FROM DUAL UNION ALL
    SELECT 'NPH_TSH',     'NPH monitoring - TSH',                             'NPH',          '-','TSH',        'DISEASE_ONLY',365,20 FROM DUAL UNION ALL
    SELECT 'NPH_B12',     'NPH monitoring - Vitamin B12',                     'NPH',          '-','VIT_B12',   'DISEASE_ONLY',365,20 FROM DUAL UNION ALL
    SELECT 'NPH_CRE',     'NPH monitoring - Creatinine',                      'NPH',          '-','CREATININE', 'DISEASE_ONLY',180,20 FROM DUAL UNION ALL
    SELECT 'ALZ_TSH',     'Alzheimer monitoring - TSH',                       'Alzheimer',    '-','TSH',        'DISEASE_ONLY',365,10 FROM DUAL UNION ALL
    SELECT 'ALZ_B12',     'Alzheimer monitoring - Vitamin B12',               'Alzheimer',    '-','VIT_B12',   'DISEASE_ONLY',365,10 FROM DUAL UNION ALL
    SELECT 'ALZ_GLUC',    'Alzheimer monitoring - Glucose',                   'Alzheimer',    '-','GLUCOSE',    'DISEASE_ONLY',365,20 FROM DUAL UNION ALL
    SELECT 'ALZ_CBC',     'Alzheimer monitoring - CBC',                       'Alzheimer',    '-','CBC',        'DISEASE_ONLY',365,20 FROM DUAL UNION ALL
    SELECT 'PKS_CBC',     'Parkinson monitoring - CBC',                       'Parkinson',    '-','CBC',        'DISEASE_ONLY',180,10 FROM DUAL UNION ALL
    SELECT 'PKS_AST',     'Parkinson monitoring - AST',                       'Parkinson',    '-','AST',        'DISEASE_ONLY',180,10 FROM DUAL UNION ALL
    SELECT 'PKS_ALT',     'Parkinson monitoring - ALT',                       'Parkinson',    '-','ALT',        'DISEASE_ONLY',180,10 FROM DUAL UNION ALL
    SELECT 'PKS_CRE',     'Parkinson monitoring - Creatinine',                'Parkinson',    '-','CREATININE', 'DISEASE_ONLY',180,20 FROM DUAL UNION ALL
    SELECT 'PKS_B12',     'Parkinson monitoring - Vitamin B12',               'Parkinson',    '-','VIT_B12',   'DISEASE_ONLY',365,20 FROM DUAL UNION ALL
    SELECT 'SCH_CBC',     'Schwannoma monitoring - CBC',                      'Schwannoma',   '-','CBC',        'DISEASE_ONLY', 90,10 FROM DUAL UNION ALL
    SELECT 'SCH_NA',      'Schwannoma monitoring - Sodium',                   'Schwannoma',   '-','NA',         'DISEASE_ONLY', 30,10 FROM DUAL UNION ALL
    SELECT 'SCH_CRE',     'Schwannoma monitoring - Creatinine',               'Schwannoma',   '-','CREATININE', 'DISEASE_ONLY',180,20 FROM DUAL UNION ALL
    SELECT 'PIT_TSH',     'Pituitary adenoma monitoring - TSH',               'Pituitary adenoma','-','TSH',   'DISEASE_ONLY', 90,10 FROM DUAL UNION ALL
    SELECT 'PIT_NA',      'Pituitary adenoma monitoring - Sodium',            'Pituitary adenoma','-','NA',     'DISEASE_ONLY', 14,10 FROM DUAL UNION ALL
    SELECT 'PIT_LH',      'Pituitary adenoma monitoring - LH',                'Pituitary adenoma','-','LH',    'DISEASE_ONLY',180,20 FROM DUAL UNION ALL
    SELECT 'TGN_NA',      'Trigeminal neuralgia monitoring - Sodium',         'Trigeminal neuralgia','-','NA', 'DISEASE_ONLY', 90,10 FROM DUAL UNION ALL
    SELECT 'TGN_CBC',     'Trigeminal neuralgia monitoring - CBC',            'Trigeminal neuralgia','-','CBC','DISEASE_ONLY', 90,10 FROM DUAL UNION ALL
    SELECT 'TGN_AST',     'Trigeminal neuralgia monitoring - AST',            'Trigeminal neuralgia','-','AST','DISEASE_ONLY',180,20 FROM DUAL UNION ALL
    SELECT 'TGN_ALT',     'Trigeminal neuralgia monitoring - ALT',            'Trigeminal neuralgia','-','ALT','DISEASE_ONLY',180,20 FROM DUAL
  ) s
  WHERE NOT EXISTS (SELECT 1 FROM CDSS_RULE_LAB r WHERE r.RULE_CODE = s.RULE_CODE);

  COMMIT;
END;
