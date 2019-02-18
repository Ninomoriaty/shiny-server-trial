FROM r-base:3.1.3

RUN apt-get update && apt-get install -y  \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libxt-dev \
    libssl-dev \
    libxml2 \
    libxml2-dev \
    apt-utils \
    # add for devtools
    build-essential
    # systemd \

# Download and install shiny server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb

# RUN wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.9.923-amd64.deb
# RUN gdebi shiny-server-1.5.9.923-amd64.deb && rm -f shiny-server-1.5.9.923-amd64.deb
# source("http://bioconductor.org/biocLite.R")
RUN R -e "install.packages(c('Rcpp', 'abind', 'tm', 'devtools', 'memoise'), repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('Biobase', 'BiocGenerics', 'S4Vectors', 'IRanges', 'GenomeInfoDb', 'GenomicRanges','impute'), repo='http://www.bioconductor.org')"
RUN R -e "install.packages(c('PoissonSeq','FactoMineR','samr','ggplot2','VennDiagram','RobustRankAggreg','shiny','rmarkdown','Cairo','gplots','pheatmap','labeling'), repo='http://www.bioconductor.org')"
RUN R -e "install.packages(c('edgeR', 'DESeq2', 'NOISeq'), repo='http://www.bioconductor.org')"

# RUN R -e "devtools::install_github('rstudio/shiny-incubator', 'rstudio/rstudio')"
# RUN R -e "devtools::install_github('AnalytixWare/ShinySky')"
RUN R -e "devtools::install_github('likelet/shinyBS')"
RUN R -e "devtools::install_github('likelet/IDEA')"


COPY shiny-server.conf  /etc/shiny-server/shiny-server.conf
COPY inst/IDEA /srv/shiny-server/

EXPOSE 80

COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh", "/bin/bash"]