#!/bin/bash

h2_results_log=$1	# LDSC heritability results log file e.g. G6_MIGRAINE.gz.h2.log

awk -v OFS="\t" 'BEGIN{ \
	n_snps="NA"; h2_obs="NA"; h2_obs_se="NA"; lambda="NA"; mean_chi2="NA"; intercept="NA"; intercept_se="NA"; ratio="NA"; \
     } \
     { \
	if($0~/After merging with regression SNP LD/){ \
		split($0, a, " "); n_snps=a[7]; \
	} \
	else if($0~/Total Observed scale h2:/){ \
		split($0, a, " "); h2_obs=a[5]; \
		split( $0, a, /[()]/ ); h2_obs_se=a[2]; \
	} \
	else if($0~/Lambda GC:/){ \
		split($0, a, " "); lambda=a[3]; \
	} \
	else if($0~/Mean Chi/){ \
		split($0, a, " "); mean_chi2=a[3]; \
	} \
	else if($0~/Intercept:/){ \
		split($0, a, " "); intercept=a[2]; \
		split($0, a, /[()]/ ); intercept_se=a[2]; \
	} \
	else if($0~/Ratio:/){ \
		split($0, a, ":"); ratio=a[2]; \
	} \
     } \
     END{ \
     	print FILENAME, n_snps, h2_obs, h2_obs_se, lambda, mean_chi2, intercept, intercept_se, ratio; \
     }' $h2_results_log
