/* KCC-Q1-ALGN-93*/

/* 0 records returned is a pass condition*/

WITH CNT_BTH_DT_TEST as
(
	SELECT ALGN.BENE_SK, YR_MNTH, CURR_UNDER_18_IND
		  , UNDER_18_IND,BENE_BRTH_DT,RUN_DT
		  ,(RUN_DT-B.BENE_BRTH_DT)/365 as BENE_AGE_RUN_DT   
	FROM CMS_ADM_CMMI_CKC_PRD.WK_KCC_ALGN_DTLS_HSTRY_IPQ2_PRD ALGN
	INNER JOIN 
		(SELECT RUN_DT, LTST_ALGN_BLD_RUN_SK 
		 FROM CMS_ADM_CMMI_CKC_PRD.KCC_BLD_PRM_IPQ2_PRD
		 WHERE BLD_ID = 'IPQ2'
	 	 AND ALGN_RUN_IND = 'PRE'
	 	) PARMT
	ON ALGN.BLD_RUN_SK = PARMT.LTST_ALGN_BLD_RUN_SK 
	INNER JOIN
		(SELECT BENE_SK,BENE_BRTH_DT
		 FROM  CMS_VDM_VIEW_MDCR_PRD.V2_MDCR_BENE BEN_DTL 
		 ) B
	ON ALGN.BENE_SK = B.BENE_SK
	WHERE BLD_RUN_SK = 20201103104930 --20200929093734 --20200929093734 --20200929093734 -- 20200929093734
	AND PROS_BENE_DSGNTN_CD = 'ESRD'
)
SELECT BENE_SK,
	   SUM(CASE WHEN CURR_UNDER_18_IND='N' THEN 1 ELSE 0 END)/COUNT(*) AS YES_CNT_O18
FROM CNT_BTH_DT_TEST
WHERE BENE_AGE_RUN_DT >= 18 
AND CURR_UNDER_18_IND = 'N'
GROUP BY BENE_SK
HAVING YES_CNT_O18 < 1
;
