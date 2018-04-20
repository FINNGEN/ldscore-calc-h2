#!/bin/bash

sumstats_file=$1     # Phenotype sumstats file e.g. G6_MIGRAINE.gz
LD_data="/eur_w_ld_chr/"

# Run LD Score Regression on all phenotypes
/ldsc/ldsc-master/ldsc.py \
	--h2 ${sumstats_file}.sumstats.gz \
	--ref-ld-chr $LD_data \
	--w-ld-chr $LD_data \
	--out ${sumstats_file}.h2
