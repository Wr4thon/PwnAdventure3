FROM alpine as build
RUN apk update && apk add ca-certificates wget tar && update-ca-certificates
# COPY --chown=pwn3 pwn3.tar.gz pwn3.tar.gz
RUN wget http://pwnadventure.com/pwn3.tar.gz
RUN tar -xvf pwn3.tar.gz

FROM ubuntu:16.04
RUN apt-get update && apt-get install -y postgresql && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 5432
ENV PWN3=/opt/pwn3
RUN mkdir $PWN3

RUN useradd -ms /bin/bash pwn3

COPY --from=build --chown=pwn3 /client $PWN3/client
COPY --from=build --chown=pwn3 /server $PWN3/server
COPY --from=build --chown=pwn3 /server/MasterServer/initdb.sql $PWN3/initdb.sql
COPY --chown=pwn3 setup $PWN3/setup
