FROM ubuntu:18.04


ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq -y update \ 
    && apt-get -qq -y install ncbi-blast+ \ 
    && umask 022 \
    && apt-get install -y python3-pip python3-dev \
    && cd /usr/local/bin \
    && ln -s /usr/bin/python3 python \
    && pip3 --no-cache-dir install --upgrade pip \
    && pip3 install biopython \
    && pip3 install pandas \
    && pip3 install entrezpy \
    && apt-get -qq -y install automake autoconf \
    && apt -qq -y install default-jre \ 
    && apt-get -qq -y install build-essential \
    && apt-get -qq -y install cd-hit \
    && apt-get -qq -y install mafft \	   
    && apt-get -qq -y install samtools \	   
    && apt-get -qq -y install curl \
    && curl -L https://github.com/lh3/minimap2/releases/download/v2.17/minimap2-2.17_x64-linux.tar.bz2 | tar -jxvf - \
    && mv ./minimap2-2.17_x64-linux/minimap2 /bin/ \
    && cd /bin/ \
    && apt-get -qq -y install git \
    && git clone https://github.com/RemiAllio/MitoFinder.git \
    && cd MitoFinder \
    && ./install.sh  \
    && cd /bin/ \
    && apt-get -qq -y install wget \
    && apt-get -qq -y install libz-dev \
    && rm -rf /var/lib/apt/lists/* \
    && wget https://github.com/chhylp123/hifiasm/archive/refs/tags/0.14.2.tar.gz \
    && tar -xzvf 0.14.2.tar.gz \
    && cd hifiasm-0.14.2 && make

ENV PATH /bin/MitoFinder/:${PATH}
ENV PATH /bin/hifiasm-0.14.2/:${PATH}

COPY mitohifi_v2.py /bin/
RUN echo "#!/usr/bin/env python" | cat - /bin/mitohifi_v2.py | tee /bin/mitohifi_v2.py
COPY gfa2fa /bin/
COPY alignContigs.py /bin/
COPY circularizationCheck.py /bin/
COPY cleanUpCWD.py /bin/
COPY filterfasta.py /bin/
COPY getMitoLength.py /bin/
COPY getReprContig.py /bin/
COPY parse_blast.py /bin/
COPY rotation.py /bin/
COPY findMitoReference.py /bin/
COPY findFrameShits.py /bin/
COPY fixContigHeaders.py /bin/

RUN chmod -R 755 /bin
CMD ["/bin/bash"]
