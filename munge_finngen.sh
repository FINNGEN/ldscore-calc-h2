#!/bin/bash

sumstats_file=$1	# Phenotype sumstats file e.g. G6_MIGRAINE.gz
LD_data="/eur_w_ld_chr/"

/ldsc/munge_sumstats.py \
	--sumstats ${sumstats_file}.zscores \
	--out ${sumstats_file} \
	--N-col N \
	--snp rsids \
	--a1 alt \
	--a2 ref \
	--p pval \
	--signed-sumstats Z,0 \
	--maf-min 0.01 \
	--frq maf \
	--merge-alleles /w_hm3.snplist \
	--info INFO
