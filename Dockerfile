FROM ummsbiocore/dolphinnext-docker:latest
MAINTAINER Alper Kucukural <alper.kucukural@umassmed.edu>
 
RUN add-apt-repository -y ppa:opencpu/opencpu-2.1
RUN add-apt-repository ppa:ubuntugis/ubuntugis-unstable
RUN apt-get update
RUN apt-get -y install opencpu-server rstudio-server \
    libudunits2-dev pandoc libmariadb-client-lgpl-dev texlive texlive-latex-extra

RUN R -e 'install.packages(c("devtools", "knitr", "RCurl", "plotly", "webshot", "rmarkdown"))'
RUN R -e 'devtools::install_github("umms-biocore/markdownapp")'
RUN R -e 'webshot::install_phantomjs()'
RUN mv /root/bin/phantomjs /usr/bin/.

RUN sed -i "s|\"rlimit.as\": 4e9|\"rlimit.as\": 12e9|" /etc/opencpu/server.conf
RUN sed -i "s|\"rlimit.fsize\": 1e9|\"rlimit.fsize\": 8e9|" /etc/opencpu/server.conf
RUN sed -i "s|\"timelimit.get\": 60|\"timelimit.get\": 900|" /etc/opencpu/server.conf
RUN sed -i "s|\"timelimit.post\": 90|\"timelimit.post\": 900|" /etc/opencpu/server.conf



RUN R -e 'if (!requireNamespace("BiocManager", quietly = TRUE))' \
      -e 'install.packages("BiocManager")' \
      -e 'BiocManager::install(c("debrowser", "scran", "scater", "BiocStyle", "destiny", "mvoutlier"), version = "3.8")'

RUN R -e 'library(devtools); install_github("garber-lab/SignallingSingleCell")'

RUN git clone https://github.com/umms-biocore/debrowser.git /data/debrowser

RUN echo "DONE!"

