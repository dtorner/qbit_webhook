FROM ghcr.io/stuffanthings/qbit_manage:develop

COPY requirements.txt /

# install packages
RUN echo "**** install system packages ****" \
 && apk update \
 && apk upgrade \
 && apk add --no-cache tzdata gcc g++ libxml2-dev libxslt-dev zlib-dev bash curl wget jq grep sed coreutils findutils unzip p7zip ca-certificates tini\
 && pip3 install --no-cache-dir --upgrade --requirement /requirements.txt \
 && apk del gcc g++ libxml2-dev libxslt-dev zlib-dev \
 && rm -rf /requirements.txt /tmp/* /var/tmp/* /var/cache/apk/*


COPY qbit-hook.py /app


