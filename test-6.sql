/* KCC-Q1-ALGN-6*/

/* 0 records returned is a pass condition*/

SELECT CLM_LD_DT, COUNT(*) 
FROM CMS_ADM_CMMI_CKC_PRD.KCC_CKD_CLMS_HSTRY_IPQ2_PRD ALGN
INNER JOIN 
(
SELECT * FROM CMS_ADM_CMMI_CKC_PRD.KCC_BLD_PRM_IPQ2_PRD 
WHERE LTST_ALGN_BLD_RUN_SK = '20201103104930' 
) BLM_PRM

ON ALGN.BLD_ID = BLM_PRM.BLD_ID 
AND ALGN.BLD_RUN_SK = BLM_PRM.LTST_ALGN_BLD_RUN_SK
--AND CKD.BLD_RUN_SK = BLD.LTST_ALGN_BLD_RUN_SK	
WHERE ALGN.CLM_LD_DT < BLM_PRM.LD_STRT_DT OR ALGN.CLM_LD_DT > BLM_PRM.LD_END_DT 
GROUP BY CLM_LD_DT
;
