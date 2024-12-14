FROM debian:12 AS sems-base

## sems dependencies
RUN apt update && apt install -y \
        git debhelper g++ make libspandsp-dev flite1-dev \
        libspeex-dev libgsm1-dev libopus-dev libssl-dev python3-dev \
        python3.11-dev libbcg729-dev \
    python3-sip-dev openssl libev-dev libmysqlcppconn-dev libevent-dev \
    libxml2-dev libcurl4-openssl-dev libhiredis-dev

## other dependencies and stuff for troubleshooting purposes
RUN apt install -y \
    debhelper  dh-virtualenv \
    vim sngrep

FROM sems-base AS sems-builder

ARG GIT_SEMS_PROJECT_URL
ARG GIT_SEMS_PROJECT_BRANCH
ARG BASE_WORKDIR

WORKDIR ${BASE_WORKDIR}

## clone repo and branch
RUN git clone ${GIT_SEMS_PROJECT_URL} --branch ${GIT_SEMS_PROJECT_BRANCH} ${BASE_WORKDIR}

RUN ls -la ${BASE_WORKDIR}

## COPY deb packaging stuff
RUN cp -rp ${BASE_WORKDIR}/pkg/deb/bookworm/  ${BASE_WORKDIR}/debian/

RUN cd ${BASE_WORKDIR} && \
    dpkg-buildpackage -rfakeroot -us -uc

FROM sems-builder AS sems

WORKDIR ${BASE_WORKDIR}

COPY entrypoint.sh .

ENTRYPOINT ["./entrypoint.sh"]
CMD ["start"]
