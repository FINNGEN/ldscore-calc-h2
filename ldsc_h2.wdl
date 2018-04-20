task calc_h2 {
	File sumstats
	File sample_nums
	File infofile
	String memory
	Int local_disk=100
	String docker
	Int cpu

	command <<<
		/pval_to_zscores.R ${sumstats} ${sample_nums} ${infofile}
		/munge_finngen.sh ${sumstats}
		/calc_h2.sh ${sumstats}
	>>>
	output {
		File out="${basename(sumstats)}.h2.log"
	}

	runtime {
		docker: "${docker}"
		memory:"${memory}"
		disks: "local-disk ${local_disk} SSD"
		cpu:"${cpu}"
	}

}

task join_h2 {
	Array[File] results_h2
	String dollar="$"
	Int local_disk=100
        String docker
	String memory
	Int cpu

	command <<<
		tempfile=${write_lines(results_h2)}
		results_string=${sep=' ' results_h2}
		array_results=($results_string)
		
		echo -e "file\tn_snps\th2_obs\th2_obs_se\tlambda\tmean_chi2\tintercept\tintercept_se\tratio" > merged_h2_results.tsv
		for ((i=0; i<${dollar}{#array_results[@]}; ++i)); do
			./format_results.sh ${dollar}{array_results[$i]} >> merged_h2_results.tsv
		done
	>>>
	
	output {
		File out="merged_h2_results.tsv"
	}
	
	runtime {
		docker: "${docker}"
		memory:"${memory}"
		disks: "local-disk ${local_disk} SSD"
		cpu:"${cpu}"
	}

}

workflow ldsc_h2 {

	File sumstats_list
	File infofile
	File sample_nums

	Array[String] files = read_lines(sumstats_list)

	String docker
	String memory
	Int cpu

	scatter(file in files) {
		call calc_h2 {
			input: sumstats=file, sample_nums=sample_nums, infofile=infofile, memory=memory, cpu=cpu,
			docker=docker
		}
	}

	call join_h2 {
		input: results_h2 = calc_h2.out, memory=memory, cpu=cpu,
		docker=docker
	}
}
