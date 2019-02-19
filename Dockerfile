FROM debian:latest

RUN apt-get update && apt-get install -y \
    wget \
    sudo \
    gdebi-core \
    # r-needed:
    r-base \
    # for devtools: https://stackoverflow.com/questions/31114991/installation-of-package-devtools-had-non-zero-exit-status-in-a-powerpc
    libcurl4-gnutls-dev \
    libxt-dev \
    libssl-dev \
    libxml2 \
    libxml2-dev \

# Download and install shiny server
RUN R -e "install.packages(c('shiny', 'devtools'), repos='http://cran.rstudio.com/')"
RUN wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.9.923-amd64.deb \
    && gdebi -n shiny-server-1.5.9.923-amd64.deb

# IDEA part:
RUN R -e "devtools::install_github('likelet/shinyBS')"
RUN R -e "devtools::install_github('likelet/IDEA')"

# COPY shiny-server.conf  /etc/shiny-server/shiny-server.conf
COPY inst/IDEA /srv/shiny-server/

EXPOSE 8787

CMD ["/bin/bash"]

# fatal problem:docker: Error response from daemon: OCI runtime create failed: container_linux.go:344: starting container process caused "exec: \"/usr/bin/shiny-server.sh\": permission denied": unknown.
