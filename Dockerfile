FROM r-base:latest

# COPY /shiny-server-section/shiny-server.sh /usr/bin/shiny-server.sh
# COPY /shiny-server-section/shiny-server.conf  /etc/shiny-server/shiny-server.conf
# COPY /shiny-server-section/neededapp /srv/shiny-server/

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
    systemd \
    && rm -rf /var/lib/apt/lists/*

# shiny-server
#RUN echo 'APT::Default-Release "stable";' > /etc/apt/apt.conf.d/default

RUN wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.9.923-amd64.deb
RUN gdebi shiny-server-1.5.9.923-amd64.deb && rm -f shiny-server-1.5.9.923-amd64.deb

#RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
#    VERSION=$(cat version.txt)  && \
#    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
#    gdebi -n ss-latest.deb && \
#    rm -f version.txt ss-latest.deb

RUN R -e "install.packages(c('Rcpp', 'shiny', 'rmarkdown', 'tm', 'wordcloud', 'memoise'), repos='http://cran.rstudio.com/')"

EXPOSE 80

CMD ["/bin/bash", "/usr/bin/shiny-server.sh"]