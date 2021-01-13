/* KCC-Q1-ALGN-32*/

/* 0 records returned is a pass condition*/

WITH BTH_DT_TEST as
(
	SELECT ALGN.BENE_SK, YR_MNTH, CURR_UNDER_18_IND
		  , UNDER_18_IND,BENE_BRTH_DT,RUN_DT
		  --,(RUN_DT-B.BENE_BRTH_DT)/365 as BENE_AGE_RUN_DT -- Birth date (all rows same) 
		  , CAST(CAST(ALGN.YR_MNTH AS VARCHAR(7)) AS DATE FORMAT 'YYYYMM') AS ALGN_YRMTH
		  , ADD_MONTHS(BENE_BRTH_DT,216) AS DATE_18
		  , SUBSTR(CAST(DATE_18 AS DATE FORMAT 'YYYYMMDD'),1,6) AS YR_MNTH_OF_18
		  , CASE WHEN (YR_MNTH_OF_18 < YR_MNTH) THEN 'N' ELSE 'Y' END AS UNDER18TAG	  
	FROM CMS_ADM_CMMI_CKC_PRD.WK_KCC_ALGN_DTLS_HSTRY_IPQ2_PRD ALGN
	INNER JOIN 
		(SELECT RUN_DT, LTST_ALGN_BLD_RUN_SK
		 		, LKBCK_STRT_DT, LKBCK_END_DT
		 FROM CMS_ADM_CMMI_CKC_PRD.KCC_BLD_PRM_IPQ2_PRD
		 WHERE BLD_ID = 'IPQ2'
	 	 AND ALGN_RUN_IND = 'PRE'
	 	) PARMT
	ON ALGN.BLD_RUN_SK = PARMT.LTST_ALGN_BLD_RUN_SK 
	INNER JOIN
		(SELECT BENE_SK, BENE_BRTH_DT
		 FROM  CMS_VDM_VIEW_MDCR_PRD.V2_MDCR_BENE BEN_DTL 
		 ) B
	ON ALGN.BENE_SK = B.BENE_SK
	WHERE BLD_RUN_SK = 20201103104930 --20200929093734 --20200929093734 --20200929093734
	AND PROS_BENE_DSGNTN_CD = 'CKD'
	AND ALGN_YRMTH >= PARMT.LKBCK_STRT_DT 
	AND ALGN_YRMTH <= PARMT.LKBCK_END_DT 
)
SELECT * FROM BTH_DT_TEST
--WHERE BENE_AGE_RUN_DT = 18
WHERE UNDER_18_IND <> UNDER18TAG
ORDER BY YR_MNTH
;
