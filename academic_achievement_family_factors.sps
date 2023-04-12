* Encoding: UTF-8.

* Preprocess

* Select students from GP school only

DATASET ACTIVATE DataSet1.
FILTER OFF.
USE ALL.
SELECT IF (school = 'GP').
EXECUTE.

* Attach unique ID for each observation

DATASET ACTIVATE DataSet1.
COMPUTE ID=$CASENUM.
EXECUTE.

* Compute Average value of three grades, Overall_G is dependent variable in the model

DATASET ACTIVATE DataSet1.
COMPUTE Overall_G=MEAN(G1,G2,G3).
EXECUTE.

* Create Dummy Variables
   
SPSSINC CREATE DUMMIES VARIABLE=famsize Pstatus Medu Fedu famsup 
ROOTNAME1=famsize_dummy, Pstatus_dummy, Medu_dummy, Fedu_dummy, famsup_dummy 
/OPTIONS ORDER=A USEVALUELABELS=YES USEML=YES OMITFIRST=NO.

* Variable Desciptions
    
DATASET ACTIVATE DataSet1.
FREQUENCIES VARIABLES=famsize Pstatus Medu Fedu famsup
  /BARCHART FREQ
  /ORDER=ANALYSIS.

DESCRIPTIVES VARIABLES=famrel Overall_G
  /STATISTICS=MEAN STDDEV RANGE MIN MAX SKEWNESS.

GRAPH
  /HISTOGRAM=Overall_G
  /TITLE='Distribution of Overall_G'.

GRAPH
  /HISTOGRAM=famrel
  /TITLE='Distribution of famrel'.

* Initial Model
* Check assumptions and linearity

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA COLLIN TOL
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Overall_G
  /METHOD=ENTER famsize_dummy_1 Pstatus_dummy_4 Medu_dummy_6 Medu_dummy_7 Medu_dummy_8 Medu_dummy_9 
    Fedu_dummy_11 Fedu_dummy_12 Fedu_dummy_13 Fedu_dummy_14 famsup_dummy_16 famrel
  /PARTIALPLOT ALL
  /SCATTERPLOT=(*SDRESID ,*ZPRED)
  /RESIDUALS HISTOGRAM(ZRESID) NORMPROB(ZRESID) ID(ID).

* Try different combination of interaction terms

COMPUTE famsup_famsize=famsup_dummy_16 * famsize_dummy_1.
EXECUTE.

COMPUTE famsup_Pstatus=famsup_dummy_16 * Pstatus_dummy_4.
EXECUTE.

COMPUTE famsup_Medu1=famsup_dummy_16 * Medu_dummy_6.
EXECUTE.

COMPUTE famsup_Medu2=famsup_dummy_16 * Medu_dummy_7.
EXECUTE.

COMPUTE famsup_Medu3=famsup_dummy_16 * Medu_dummy_8.
EXECUTE.

COMPUTE famsup_Medu4=famsup_dummy_16 * Medu_dummy_9.
EXECUTE.

COMPUTE famsup_Fedu1=famsup_dummy_16 * Fedu_dummy_11.
EXECUTE.

COMPUTE famsup_Fedu2=famsup_dummy_16 * Fedu_dummy_12.
EXECUTE.

COMPUTE famsup_Fedu3=famsup_dummy_16 * Fedu_dummy_13.
EXECUTE.

COMPUTE famsup_Fedu4=famsup_dummy_16 * Fedu_dummy_14.
EXECUTE.

COMPUTE famsup_famrel=famsup_dummy_16 * famrel.
EXECUTE.

* Incremental F-test

* Significant famsup_famsiz

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Overall_G
  /METHOD=ENTER famsize_dummy_1 Pstatus_dummy_4 Medu_dummy_6 Medu_dummy_7 Medu_dummy_8 Medu_dummy_9 
    Fedu_dummy_11 Fedu_dummy_12 Fedu_dummy_13 Fedu_dummy_14 famsup_dummy_16 famrel
  /METHOD=ENTER famsup_famsize
  /SCATTERPLOT=(*SDRESID ,*ZPRED).

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Overall_G
  /METHOD=ENTER famsize_dummy_1 Pstatus_dummy_4 Medu_dummy_6 Medu_dummy_7 Medu_dummy_8 Medu_dummy_9 
    Fedu_dummy_11 Fedu_dummy_12 Fedu_dummy_13 Fedu_dummy_14 famsup_dummy_16 famrel famsup_famsize
  /METHOD=ENTER famsup_Pstatus
  /SCATTERPLOT=(*SDRESID ,*ZPRED).

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Overall_G
  /METHOD=ENTER famsize_dummy_1 Pstatus_dummy_4 Medu_dummy_6 Medu_dummy_7 Medu_dummy_8 Medu_dummy_9 
    Fedu_dummy_11 Fedu_dummy_12 Fedu_dummy_13 Fedu_dummy_14 famsup_dummy_16 famrel famsup_famsize
  /METHOD=ENTER famsup_Medu1 famsup_Medu2 famsup_Medu3 famsup_Medu4
  /SCATTERPLOT=(*SDRESID ,*ZPRED).

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Overall_G
  /METHOD=ENTER famsize_dummy_1 Pstatus_dummy_4 Medu_dummy_6 Medu_dummy_7 Medu_dummy_8 Medu_dummy_9 
    Fedu_dummy_11 Fedu_dummy_12 Fedu_dummy_13 Fedu_dummy_14 famsup_dummy_16 famrel famsup_famsize
  /METHOD=ENTER famsup_Fedu1 famsup_Fedu2 famsup_Fedu3 famsup_Fedu4
  /SCATTERPLOT=(*SDRESID ,*ZPRED).

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Overall_G
  /METHOD=ENTER famsize_dummy_1 Pstatus_dummy_4 Medu_dummy_6 Medu_dummy_7 Medu_dummy_8 Medu_dummy_9 
    Fedu_dummy_11 Fedu_dummy_12 Fedu_dummy_13 Fedu_dummy_14 famsup_dummy_16 famrel famsup_famsize
  /METHOD=ENTER famsup_famrel
  /SCATTERPLOT=(*SDRESID ,*ZPRED).

* Final model

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA COLLIN TOL
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Overall_G
  /METHOD=ENTER famsize_dummy_1 Pstatus_dummy_4 Medu_dummy_6 Medu_dummy_7 Medu_dummy_8 Medu_dummy_9 
    Fedu_dummy_11 Fedu_dummy_12 Fedu_dummy_13 Fedu_dummy_14 famsup_dummy_16 famrel famsup_famsize
  /PARTIALPLOT ALL
  /SCATTERPLOT=(*SDRESID ,*ZPRED)
  /RESIDUALS HISTOGRAM(ZRESID) NORMPROB(ZRESID) ID(ID)
  /SAVE COOK SDRESID SDBETA.

* VIF really high so recategorize into no-higher education and higher-education

RECODE Medu (0=0) (1=0) (2=0) (3=0) (4=1) INTO Medu_recat.
EXECUTE.

RECODE Fedu (0=0) (1=0) (2=0) (3=0) (4=1) INTO Fedu_recat.
EXECUTE.

SPSSINC CREATE DUMMIES VARIABLE=Medu_recat Fedu_recat 
ROOTNAME1=Medu_recat_dummy, Fedu_recat_dummy 
/OPTIONS ORDER=A USEVALUELABELS=YES USEML=YES OMITFIRST=NO.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA COLLIN TOL
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT Overall_G
  /METHOD=ENTER famsize_dummy_1 Pstatus_dummy_4 famsup_dummy_16 famrel famsup_famsize 
    Medu_recat_dummy_2 Fedu_recat_dummy_4
  /PARTIALPLOT ALL
  /SCATTERPLOT=(*SDRESID ,*ZPRED)
  /RESIDUALS HISTOGRAM(ZRESID) NORMPROB(ZRESID) ID(ID)
  /SAVE COOK SDRESID SDBETA.

* check outlier Cook's Distance (4 / (349 – 7 - 1)) = 0.0117 (largest value 0.04 not even close to 1) 
    

