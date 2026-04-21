BEGIN
  MERGE INTO CDSS_DRUG_MAP tgt
  USING (
    SELECT 'TEG102E'  HIS_DRUG_CODE,'TEGRETOL CR 200 MG (CARBAMAZEPINE)'        HIS_DRUG_NAME,'Carbamazepine'  DRUG_GROUP FROM DUAL UNION ALL
    SELECT 'TEG301E', 'TEGRETOL SYR 100MG/5ML (CARBAMAZEPINE)',                 'Carbamazepine'                           FROM DUAL UNION ALL
    SELECT 'TRI106N', 'TRILEPTAL 300 MG TAB (OXCARBAZEPINE)',                   'Oxcarbazepine'                           FROM DUAL UNION ALL
    SELECT 'TRI107N', 'TRILEPTAL 600 MG TAB (OXCARBAZEPINE)',                   'Oxcarbazepine'                           FROM DUAL UNION ALL
    SELECT 'DEP101E', 'DEPAKINE 200 MG (VALPROATE)',                            'Valproate'                               FROM DUAL UNION ALL
    SELECT 'DEP104E', 'DEPAKINE 500 MG CHRONO (VALPROATE)',                     'Valproate'                               FROM DUAL UNION ALL
    SELECT 'DEP302E', 'DEPAKINE SYR (VALPROATE)',                               'Valproate'                               FROM DUAL UNION ALL
    SELECT 'DEP203E', 'DEPAKINE INJ 400MG/4ML (VALPROATE)',                     'Valproate'                               FROM DUAL UNION ALL
    SELECT 'SOD208N', 'SODIUM VALPROATE INJ (VALPROATE)',                       'Valproate'                               FROM DUAL UNION ALL
    SELECT 'DIL101E', 'DILANTIN 100 MG CAP (PHENYTOIN)',                        'Phenytoin'                               FROM DUAL UNION ALL
    SELECT 'DIL107E', 'DILANTIN INFA 50 MG TAB (PHENYTOIN)',                    'Phenytoin'                               FROM DUAL UNION ALL
    SELECT 'DIL201E', 'DILANTIN INJ 250MG/5ML (PHENYTOIN)',                     'Phenytoin'                               FROM DUAL UNION ALL
    SELECT 'DIL300N', 'DILANTIN SUSPENSION 125MG/5ML (PHENYTOIN)',              'Phenytoin'                               FROM DUAL UNION ALL
    SELECT 'PHE203E', 'PHENYTOIN SODIUM INJ 250MG/5ML (UTOIN)',                 'Phenytoin'                               FROM DUAL UNION ALL
    SELECT 'PHE101E', 'PHENOBARB 60 MG TAB',                                   'Phenobarbital'                           FROM DUAL UNION ALL
    SELECT 'PHE103E', 'PHENOBARBITONE 30 MG TAB (GPO)',                         'Phenobarbital'                           FROM DUAL UNION ALL
    SELECT 'PHE202E', 'PHENOBARBITAL SODIUM INJ 200MG/ML',                      'Phenobarbital'                           FROM DUAL UNION ALL
    SELECT 'PHE304N', 'PHENOBARBITAL 5MG/ML SYR',                               'Phenobarbital'                           FROM DUAL UNION ALL
    SELECT 'KEP100N', 'KEPPRA 500 MG TAB (LEVETIRACETAM)',                      'Levetiracetam'                           FROM DUAL UNION ALL
    SELECT 'KEP200N', 'KEPPRA INJ 500MG/5ML (LEVETIRACETAM)',                   'Levetiracetam'                           FROM DUAL UNION ALL
    SELECT 'KEP300N', 'KEPPRA SYRUP 100MG/ML (LEVETIRACETAM)',                  'Levetiracetam'                           FROM DUAL UNION ALL
    SELECT 'LEV109E', 'LEVETIRACETAM (LETTA) 500 MG TAB',                      'Levetiracetam'                           FROM DUAL UNION ALL
    SELECT 'LEV110E', 'LEPPA LEVETIRACETAM 500 MG TAB',                        'Levetiracetam'                           FROM DUAL UNION ALL
    SELECT 'LAM104N', 'LAMICTAL 25 MG TAB (LAMOTRIGINE)',                       'Lamotrigine'                             FROM DUAL UNION ALL
    SELECT 'LAM105N', 'LAMICTAL 50 MG TAB (LAMOTRIGINE)',                       'Lamotrigine'                             FROM DUAL UNION ALL
    SELECT 'LAM106N', 'LAMICTAL 100 MG TAB (LAMOTRIGINE)',                      'Lamotrigine'                             FROM DUAL UNION ALL
    SELECT 'TOP101N', 'TOPAMAX 25 MG TAB (TOPIRAMATE)',                         'Topiramate'                              FROM DUAL UNION ALL
    SELECT 'TOP102N', 'TOPAMAX 100 MG TAB (TOPIRAMATE)',                        'Topiramate'                              FROM DUAL UNION ALL
    SELECT 'TOP103N', 'TOPAMAX 50 MG TAB (TOPIRAMATE)',                         'Topiramate'                              FROM DUAL UNION ALL
    SELECT 'TOP104E', 'PITOMATE 25 MG TAB (TOPIRAMATE)',                        'Topiramate'                              FROM DUAL UNION ALL
    SELECT 'TOP105E', 'PITOMATE 50 MG TAB (TOPIRAMATE)',                        'Topiramate'                              FROM DUAL UNION ALL
    SELECT 'TOP106E', 'PITOMATE 100 MG TAB (TOPIRAMATE)',                       'Topiramate'                              FROM DUAL UNION ALL
    SELECT 'LYR101N', 'LYRICA 75 MG CAP (PREGABALIN)',                          'Pregabalin'                              FROM DUAL UNION ALL
    SELECT 'LYR103N', 'LYRICA 25 MG CAP (PREGABALIN)',                          'Pregabalin'                              FROM DUAL UNION ALL
    SELECT 'BRI105N', 'BRILLIOR 50 MG CAP (PREGABALIN)',                        'Pregabalin'                              FROM DUAL UNION ALL
    SELECT 'PRE115N', 'PREGABALIN 25 MG CAP (EURODRUG)',                        'Pregabalin'                              FROM DUAL UNION ALL
    SELECT 'PRE116N', 'PREGABALIN 75 MG CAP (EURODRUG)',                        'Pregabalin'                              FROM DUAL UNION ALL
    SELECT 'PRE117N', 'PREGABALIN 150 MG CAP (PEBARIN)',                        'Pregabalin'                              FROM DUAL UNION ALL
    SELECT 'P-7250',  'BKD PRECIUS 75 MG (PREGABALIN)',                         'Pregabalin'                              FROM DUAL UNION ALL
    SELECT 'P-7514',  'TEVA PREGABALIN 25MG',                                  'Pregabalin'                              FROM DUAL UNION ALL
    SELECT 'GAB100E', 'GABAPENTIN 100 MG CAP (VULTIN)',                         'Gabapentin'                              FROM DUAL UNION ALL
    SELECT 'GAB103E', 'GABAPENTIN 300 MG CAP (BERLONTIN)',                      'Gabapentin'                              FROM DUAL UNION ALL
    SELECT 'GAB106E', 'GABAPENTIN 600 MG TAB (NEUPENTIN)',                      'Gabapentin'                              FROM DUAL UNION ALL
    SELECT 'GAB107E', 'GABAPENTIN 100 MG CAP (SANDOZ)',                         'Gabapentin'                              FROM DUAL UNION ALL
    SELECT 'P-7574',  'VULTIN 100MG TAB (GABAPENTIN)',                          'Gabapentin'                              FROM DUAL UNION ALL
    SELECT 'P-7575',  'VULTIN 300MG TAB (GABAPENTIN)',                          'Gabapentin'                              FROM DUAL
  ) src ON (tgt.HIS_DRUG_CODE = src.HIS_DRUG_CODE)
  WHEN NOT MATCHED THEN
    INSERT (HIS_DRUG_CODE, HIS_DRUG_NAME, DRUG_GROUP, IS_ACTIVE, CREATED_AT)
    VALUES (src.HIS_DRUG_CODE, src.HIS_DRUG_NAME, src.DRUG_GROUP, 'Y', SYSDATE);

  COMMIT;
END;
