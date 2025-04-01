FROM ubuntu:24.04



RUN mkdir -p /opt
RUN mkdir -p /data/indir
RUN mkdir -p /data/outdir


RUN chown -R 1000:1000 /data/indir /data/outdir /opt

RUN apt-get update && apt-get install -y  git build-essential make wget  zlib1g-dev libc6 python3 python3-pip &&\
	pip install snakemake --break-system-packages


# Build and install FLASH2, vidjil-algo and germline data
RUN git clone https://github.com/dstreett/FLASH2.git && \
	cd FLASH2 && make && mv flash2 /usr/local/bin/ && cd .. &&\
	rm -r FLASH2

RUN	git clone https://gitlab.inria.fr/vidjil/vidjil.git &&\
	cd vidjil &&\
	git checkout release-2025.02 &&\
	make algo germline &&\
	mv germline .. && mv vidjil-algo /usr/local/bin/ && cd .. &&\
	rm -r vidjil

RUN cd germline && wget https://gitlab.inria.fr/vidjil/contrib/-/raw/master/preprocess/vdj_filter.g && cd ..


# COPY vidjil-algo /usr/local/bin/vidjil-algo
# COPY flash2 /usr/local/bin/flash2

COPY Snakefile /opt/Snakefile
COPY config.json /opt/config.json
COPY vdj_filter.g /germline/vdj_filter.g

RUN chown -R 1000:1000 /germline
USER 1000:1000
ENV XDG_CACHE_HOME=/data/indir

WORKDIR /opt



ENTRYPOINT [ "snakemake", "-c", "8" ]
