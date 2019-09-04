FROM ummsbiocore/dolphinnext-docker:latest
MAINTAINER Alper Kucukural <alper.kucukural@umassmed.edu>
 
RUN echo "Alper"
RUN add-apt-repository -y ppa:opencpu/opencpu-2.1
RUN add-apt-repository ppa:ubuntugis/ubuntugis-unstable
RUN apt-get update
RUN gpg --keyserver hkp://keyserver.ubuntu.com:80  --recv-key E084DAB9
RUN gpg -a --export E084DAB9 | apt-key add -
RUN add-apt-repository 'deb https://ftp.ussg.iu.edu/CRAN/bin/linux/ubuntu xenial/'
RUN apt-get -y install r-base r-base-dev opencpu-server rstudio-server \
    libudunits2-dev pandoc libmariadb-client-lgpl-dev texlive texlive-latex-extra squashfs-tools

RUN R -e 'install.packages(c("devtools", "knitr", "RCurl", "plotly", "webshot", "rmarkdown"))'
RUN R -e 'devtools::install_github("umms-biocore/markdownapp")'
RUN R -e 'webshot::install_phantomjs()'
RUN mv /root/bin/phantomjs /usr/bin/.

RUN sed -i "s|\"rlimit.as\": 4e9|\"rlimit.as\": 12e9|" /etc/opencpu/server.conf
RUN sed -i "s|\"rlimit.fsize\": 1e9|\"rlimit.fsize\": 8e9|" /etc/opencpu/server.conf
RUN sed -i "s|\"timelimit.get\": 60|\"timelimit.get\": 900|" /etc/opencpu/server.conf
RUN sed -i "s|\"timelimit.post\": 90|\"timelimit.post\": 900|" /etc/opencpu/server.conf

RUN genome_url="https://galaxyweb.umassmed.edu/pub/dnext_data/genome_data/mousetest/mm10/" && \
    genome_dir="$HOME/genome_data" && \
    mkdir -p ${genome_dir}/mousetest/mm10 && \
    wget -l inf -nc -nH --cut-dirs=5 -R 'index.html*' -r --no-parent --directory-prefix=${genome_dir}/mousetest/mm10 $genome_url
RUN singularity_dir="$HOME/.dolphinnext/singularity" && \
    singularity_url="https://galaxyweb.umassmed.edu/pub/dnext_data/singularity/UMMS-Biocore-rna-seq-1.0.img" && \
    wget --directory-prefix=$singularity_dir $singularity_url 

RUN echo "DONE!"

