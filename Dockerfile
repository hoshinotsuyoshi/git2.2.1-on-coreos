FROM debian:jessie
RUN apt-get update && \
    apt-get -y install libcurl4-gnutls-dev libexpat1-dev gettext \
      libz-dev libssl-dev wget build-essential zlib1g-dev && \
    export DIR=/opt && \
    mkdir -p $DIR/source && \
    cd $DIR/source && \
    wget "https://www.kernel.org/pub/software/scm/git/git-2.2.1.tar.gz" && \
    tar xzvf git-2.2.1.tar.gz 

RUN export DIR=/opt && \
    cd $DIR/source/git-2.2.1 && \
    ./configure --prefix=$DIR/git-2.2.1-static CFLAGS="${CFLAGS} -static" NO_OPENSSL=1 NO_CURL=1 && \
    make && \
    make install

RUN echo '#!/bin/sh\n\
if mountpoint -q /target; then\n\
    echo "Installing git to /target"\n\
    cp /opt/git-2.2.1-static/bin/git /target/git\n\
else\n\
    echo "/target is not a mountpoint."\n\
    echo "- re-run this with -v /opt/bin:/target"\n\
fi\n\
' > /install.sh && \
    chmod +x /install.sh

CMD /install.sh
