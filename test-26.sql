/* KCC-Q1-ALGN-26*/

/* 0 records returned is a pass condition*/

WITH TEST_DATA AS

(SELECT  ALGN.BENE_SK, ALGN.PROS_BENE_DSGNTN_CD, YR_MNTH, CURR_MSP_IND, MSP_IND, 
		 PARMT.RUN_DT, BENE_INSRNC_TYPE_CD,
		 BENE_MDCL_CVRG_TYPE_CD, 
		 BENE_MSP_CVRG_STUS_CD, 
		 BENE_INSRNC_BGN_DT, BENE_INSRNC_END_DT, 
		 IDR_TRANS_efCtv_TS, IDR_TRANS_OBSLT_TS,
		 /* Run Date falls within Ins start and End Date */
		 CASE WHEN (PARMT.RUN_DT BETWEEN BENE_INSRNC_BGN_DT AND BENE_INSRNC_END_DT) 
		 			AND (ALGN.YR_MNTH=CAST(SUBSTR(PARMT.RUN_DT,1,6) AS INTEGER))
		 	  THEN 'Y'
			  END AS RUN_MTH_MSP
 FROM CMS_ADM_CMMI_CKC_PRD.WK_KCC_ALGN_DTLS_HSTRY_IPQ2_PRD ALGN
 /* Getting Build Parameters */
 INNER JOIN 
	(
	  SELECT *
	    FROM CMS_ADM_CMMI_CKC_PRD.KCC_BLD_PRM_IPQ2_PRD
	    WHERE BLD_ID = 'IPQ2' 
		AND ALGN_RUN_IND = 'PRE'	
	) PARMT
-- ON ALGN.BLD_ID = PARMT.BLD_ID
ON PARMT.LTST_ALGN_BLD_RUN_SK = ALGN.BLD_RUN_SK
/*Getting Insurance/Policy data from IDR*/
INNER JOIN CMS_VDM_VIEW_MDCR_PRD.V2_MDCR_BENE_MI_PRFL MSP
ON ALGN.BENE_SK = MSP.BENE_SK
/* Filtering */
/*Medicare is primary*/
WHERE CURR_MSP_IND = 'N' 
/*Need Run date between Ins Start and End Date*/
AND RUN_MTH_MSP = 'Y'

/*Conditions that mean Medicare is Secondary Payer */
AND BENE_INSRNC_TYPE_CD IN ('12','13','43')
AND BENE_MDCL_CVRG_TYPE_CD = 'P'
AND BENE_MSP_CVRG_STUS_CD IN ('Y', '~')
/* Use info not obsolete as of today */
AND PARMT.RUN_DT BETWEEN CAST(SUBSTR(CAST (IDR_TRANS_EFCTV_TS AS DATE FORMAT 'YYYYMMDD'), 1, 6) AS INTEGER) 
AND CAST(SUBSTR(CAST (IDR_TRANS_OBSLT_TS AS DATE FORMAT 'YYYYMMDD'), 1, 6) AS INTEGER)
)	
/* Benes coded as Not MSP in KCC Table are MSP using IDR data */

SELECT PROS_BENE_DSGNTN_CD, COUNT(DISTINCT BENE_SK)
--BENE_DSGNTN_CD, IDR_TRANS_efCtv_TS, IDR_TRANS_OBSLT_TS -- 
FROM TEST_DATA
GROUP BY PROS_BENE_DSGNTN_CD
