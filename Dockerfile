FROM muxueqz/ckb-explorer-server-base
LABEL description="Nervos CKB is a public permissionless blockchain, the common knowledge layer of Nervos network."
LABEL maintainer="Nervos Core Dev <dev@nervos.org>"

#WORKDIR /var/lib/ckb
WORKDIR /root/

#COPY --from=ckb-orig /bin/ckb /bin/ckb
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
 libpq5 libsodium23 gcc git unzip tzdata

RUN apt-get install -y \
 zlib1g-dev libxml2-dev
RUN git clone --depth=1 \
    -b aggron \
    https://github.com/nervosnetwork/ckb-explorer.git \
    /opt/ckb-explorer-server \
  && cd /opt/ckb-explorer-server \
  && bundle install

COPY ./entrypoint.sh .

RUN rm -rf /root/pkgs

EXPOSE 8080
ENTRYPOINT ["/root/entrypoint.sh"]
