FROM openjdk:alpine

RUN apk --no-cache -U upgrade \
    && \
    apk add --no-cache -U java-cacerts \
    && \
    ln -sf /etc/ssl/certs/java/cacerts $JAVA_HOME/jre/lib/security/cacerts

ADD ./run.sh /bin/run.sh

RUN addgroup -S java \
    && \
    adduser -D -G java -u 1000 -s /bin/bash -h /home/java java \
    && \
    mkdir /app \
    && \
    chown -R java:java /home/java /etc/ssl/certs /app \
    && \
    chmod +x /bin/run.sh

WORKDIR /app

# Update apk repositories & install chromium
RUN echo "http://dl-2.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories \
    && echo "http://dl-2.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-2.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk -U --no-cache \
	--allow-untrusted add \
    zlib-dev \
    chromium \
    xvfb \
    wait4ports \
    xorg-server \
    dbus \
    ttf-freefont \
    grep \ 
    udev \
    && apk del --purge --force linux-headers binutils-gold gnupg zlib-dev libc-utils \
    && rm -rf /var/lib/apt/lists/* \
    /var/cache/apk/* \
    /usr/share/man \
    /tmp/* \
    /usr/lib/node_modules/npm/man \
    /usr/lib/node_modules/npm/doc \
    /usr/lib/node_modules/npm/html \
    /usr/lib/node_modules/npm/scripts

# ls -la
RUN ls -la /usr/bin/chromium-browser

# Add Chrome as a user
RUN adduser -D chrome
#RUN adduser -D chrome \
#    && chown -R chrome:chrome /usr/src/app

# Run Chrome as non-privileged
USER chrome

ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/

USER java

# Autorun chrome headless with no GPU
ENTRYPOINT ["chromium-browser", "--headless", "--disable-gpu", "--disable-software-rasterizer" ]
# ENTRYPOINT ["/bin/run.sh" ]
