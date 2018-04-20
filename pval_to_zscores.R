#!/usr/lib/R/bin/Rscript
# Run like: ./pval_to_zscores.R G6_MIGRAINE.gz pheno-list.txt release1_infofiltered_ALL_CHR.info.uniq.gz
rm(list=ls())

args <- commandArgs(TRUE)
sumstats <- args[1]		# Phenotype sumstats file: e.g. G6_MIGRAINE.gz
sample_file <- args[2]		# Phenocodes table with cases/control numbers
info_scores <- args[3]		# Imputation INFO scores file

# Extract current phenotype name from filename, e.g. G6_MIGRAINE.gz 
pheno <- unlist(strsplit(basename(sumstats),"[.]"))[1]

# Read finngen pheno summary stats (.gz file format)
dat <- read.table( gzfile(sumstats), head=F, sep="\t" )
colnames(dat) <- c("chrom", "pos", "ref", "alt", "rsids", "nearest_genes", "pval", "beta", "sebeta", "maf", "maf_cases", "maf_controls")

# Read in sample numbers from json file
dat_samples <- read.table( sample_file, head=T, sep="\t")
n_cases <- dat_samples$num_cases[ dat_samples$phenocode==pheno ]
n_controls <- dat_samples$num_controls[ dat_samples$phenocode==pheno ]
n_samples <- n_cases + n_controls

# Calculate signed Z-scores from p-values and crude betas
dat$Z <- sign(dat$beta) * qnorm(1-(dat$pval/2))

# Add column with sample N
dat$N <-rep( n_samples, length(dat$rsids) )

# Get info scores and merge with finngen summary stats
finngen_info <- read.table( info_scores, head=T, sep="\t" )
dat_merged <- merge(dat, finngen_info, by.x=c("chrom","pos","ref","alt"), by.y=c("CHR","POS","REF","ALT"), all.x=F, all.y=F, sort=F)

# Write out filtered sumstats LDSC input file
write.table( dat_merged, file=paste( sumstats, ".zscores", sep=""), quote=F, row.names=F, sep="\t" )
