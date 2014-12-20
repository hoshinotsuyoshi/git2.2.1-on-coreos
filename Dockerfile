FROM debian:jessie
RUN apt-get update && \
    apt-get -y install libcurl4-gnutls-dev libexpat1-dev gettext \
      libz-dev libssl-dev wget build-essential zlib1g-dev && \
    export DIR=/opt && \
    mkdir -p $DIR/source && \
    cd $DIR/source && \
    wget "https://www.kernel.org/pub/software/scm/git/git-2.2.1.tar.gz" && \
    tar xzvf git-2.2.1.tar.gz && \
    cd $DIR/source/git-2.2.1 && \
    ./configure --prefix=$DIR all && \
    make && \
    make install

RUN echo '#!/bin/sh\n\
if mountpoint -q /target; then\n\
    echo "Installing git to /target"\n\
    cp -r /opt/* /target\n\
else\n\
    echo "/target is not a mountpoint."\n\
    echo "- re-run this with -v /opt:/target"\n\
fi\n\
' > /install.sh && \
    chmod +x /install.sh

CMD /install.sh
