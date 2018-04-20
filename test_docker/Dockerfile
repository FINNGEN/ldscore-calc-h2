FROM ubuntu:16.04
ADD pval_to_zscores.R munge_finngen.sh calc_h2.sh format_results.sh /
RUN apt-get update
RUN apt-get install -qqy r-base
RUN apt-get install -qqy git
RUN apt-get install -qqy wget
RUN apt-get install -qqy curl
RUN apt-get install -qqy bzip2
RUN apt-get install -qqy unzip
RUN apt-get install -qqy python-dev
RUN apt-get install -qqy python-setuptools
RUN easy_install -U pip
RUN pip install -U argparse==1.3.0 bitarray==0.8.1 nose==1.3.4 numpy==1.8.0 pandas==0.17.0 scipy==0.11.0
RUN mkdir -p /ldsc/ && \
	wget --quiet -P /ldsc/ https://github.com/bulik/ldsc/archive/master.zip && \
	unzip -q /ldsc/master.zip -d /ldsc
RUN cd /
RUN wget https://data.broadinstitute.org/alkesgroup/LDSCORE/eur_w_ld_chr.tar.bz2
RUN tar -jxvf eur_w_ld_chr.tar.bz2
RUN wget https://data.broadinstitute.org/alkesgroup/LDSCORE/w_hm3.snplist.bz2
RUN bunzip2 w_hm3.snplist.bz2
CMD [ "/bin/bash" ]
