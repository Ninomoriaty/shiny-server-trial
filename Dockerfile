FROM r-base:3.5.0

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
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-14.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-14.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb

# IDEA part:
RUN R -e "install.packages(c('devtools'), repos='http://cran.rstudio.com/')"
RUN R -e "devtools::install_github('likelet/shinyBS')"
RUN R -e "devtools::install_github('likelet/IDEA')"

COPY shiny-server.conf  /etc/shiny-server/shiny-server.conf
COPY inst/IDEA /srv/shiny-server/

EXPOSE 8787

COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]

# fatal problem:docker: Error response from daemon: OCI runtime create failed: container_linux.go:344: starting container process caused "exec: \"/usr/bin/shiny-server.sh\": permission denied": unknown.
