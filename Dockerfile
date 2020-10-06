FROM python:3

ARG NSO_VERSION

ENV NSO_VERSION=${NSO_VERSION}
ENV DEBIAN_FRONTEND=noninteractive
ENV NCS_DIR=/nso
ENV LD_LIBRARY_PATH=/nso/lib PYTHONPATH=/nso/src/ncs/pyapi
ENV PATH=/nso/bin:$PATH

COPY nso-${NSO_VERSION}.linux.x86_64.installer.bin /tmp
WORKDIR /nso
RUN pip install --upgrade pip \
    && pip install --no-cache-dir paramiko lxml pexpect pytest \
    && apt-get update \
    && apt-get install -y --no-install-recommends libxml2-utils xsltproc git default-jre emacs-nox vim openssh-server ant \
    && /tmp/nso-${NSO_VERSION}.linux.x86_64.installer.bin /nso \
    && rm -rf examples.ncs doc

RUN apt-get install -y --no-install-recommends default-jre

WORKDIR /ncs-run
ADD Makefile /ncs-run

WORKDIR /nso
ADD run.sh /nso

EXPOSE 22 2022 2024 8080 8888
CMD [ "./run.sh" ]
