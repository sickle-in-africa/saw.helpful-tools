#
#  SIMULATE COVARIATES
#  ===================
#
#  It is necessary when running a GWAS workflow to have covariates for
#  each sample in your cohort for the association analysis. Sometimes,
#  when testing the workflow we do not have these covariates, in which
#  case it can be useful to use simulated ones. This script takes as 
#  input a fam file, and then, for the family and sample ids in this 
#  fam file, generates fake covarites. The output is saved in the
#  .cov format specfied by plink2:
#  
#  https://www.cog-genomics.org/plink/2.0/data#write_covar
#
######################################################################

library(tidyverse)

input_fam_path <- '/home/jack/computer/genemap/sadacc-workflows/gwas-workflow/projects/test-h3agwas/data/input-data/simulating-covariates/test.fam'

output_cov_path <- 'test.cov'

read.csv(input_fam_path, header=FALSE, sep=" ") -> fam

c('FID','IID','PAT','MAT','SEX','PHENO1') -> colnames(fam)

fam %>%
    as_tibble %>%
    mutate(SID=IID) %>% 
    mutate(ethnicity=ifelse(runif(nrow(fam))<0.5,'west','east')) %>%
    mutate(age=rbinom(nrow(fam), 90,.1)) %>%
    select(FID,IID,ethnicity,age) -> cov

cov %>% write.table(
    output_cov_path, 
    sep=" ", 
    quote=FALSE, 
    row.names=FALSE)
