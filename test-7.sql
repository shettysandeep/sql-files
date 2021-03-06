/* KCC-Q1-ALGN-7*/

/* 0 records returned is a pass condition*/

SELECT COUNT(*)
FROM 
CMS_ADM_CMMI_CKC_PRD.KCC_CKD_CLMS_HSTRY_IPQ2_PRD CKDVAL
CROSS JOIN (
			SELECT * 
			FROM CMS_ADM_CMMI_CKC_PRD.KCC_BLD_PRM_IPQ2_PRD
			WHERE BLD_ID = 'IPQ2' 
			AND ALGN_RUN_IND = 
			'PRE') PARMT
INNER JOIN CMS_VDM_VIEW_MDCR_PRD.V2_MDCR_CLM CLM
		ON  CLM.GEO_BENE_SK     = CKDVAL.GEO_BENE_SK
        AND CLM.CLM_DT_SGNTR_SK = CKDVAL.CLM_DT_SGNTR_SK
        AND CLM.CLM_TYPE_CD     = CKDVAL.CLM_TYPE_CD
        AND CLM.CLM_NUM_SK      = CKDVAL.CLM_NUM_SK
        AND CLM.CLM_FROM_DT     = CKDVAL.CLM_FROM_DT 

WHERE CLM.CLM_ADJSTMT_TYPE_CD NOT IN ('0', '2', ' 0', ' 2') 
AND CLM.CLM_EFCTV_DT  >= PARMT.CLM_REF_DT
AND CLM.CLM_OBSLT_DT  <  PARMT.CLM_REF_DT
AND CLM.CLM_IDR_LD_DT >  PARMT.CLM_REF_DT
AND CLM.CLM_ERR_SGNTR_SK = '3'
;
