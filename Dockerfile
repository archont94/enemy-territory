FROM debian:buster-slim

# labels
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/archont94/enemy-territory"

# define default env variables
ENV PORT=27960
ENV MAXPLAYERS=32
ENV PUNKBUSTER=1

# install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -qqy install libc6:i386 wget unzip nano && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Download and install base game
RUN mkdir -p /et/ && \
    mkdir -p /tmp/etsetup/ && \
    cd /tmp/etsetup/ && \
    wget -q  https://cdn.splashdamage.com/downloads/games/wet/et260b.x86_full.zip && \
    unzip -qq et260b.x86_full.zip && \
    ./et260b.x86_keygen_V03.run --noexec --target /tmp/etsetup/extracted && \
    mv extracted/* /et/ && \
    cd /et/ && \
    mv bin/Linux/x86/etded.x86 . && \
    rm -rf CHANGES Docs/ etkey.run etkey.sh makekey openurl.sh README ET.xpm setup.sh setup.data bin && \
    rm -rf /tmp/etsetup

# Download ETTV and ETPro
RUN cd /et/ && \
    wget -q https://www.gamestv.org/drop/ettv.x86 && \
    chmod +x ettv.x86 && \
    wget -q https://www.gamestv.org/drop/etpro-3_2_6.zip && \
    unzip -qq etpro-3_2_6.zip && \
    rm -rf etpro-3_2_6.zip && \ 
    cd etpro && \
    wget -q https://www.gamestv.org/drop/globalconfigsv1_3.zip && \
    unzip -qq globalconfigsv1_3.zip && \
    rm -rf globalconfigsv1_3.zip && \
    cd .. 
    
COPY server.cfg /et/etpro/server.cfg 


# start server
WORKDIR /et
ENTRYPOINT /et/ettv.x86 \
           +set dedicated 2 \
           +set vm_game 0 \
           +set net_port $PORT \
           +set sv_maxclients $MAXPLAYERS \
           +set fs_game etpro \
           +set sv_punkbuster $PUNKBUSTER \
           +set fs_basepath "/et" \
           +set fs_homepath "/et" \
           +exec server.cfg

