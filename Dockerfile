# Dockerfile for making Algernon serve HTTP on port 80 and HTTPS+HTTP/2 on port 443

FROM golang:alpine
MAINTAINER Alphard

RUN apk add libcap shadow git &&\
    groupadd -r algernon &&\
    useradd -r -g algernon -d /srv/algernon -s /sbin/nologin algernon
RUN go get github.com/xyproto/algernon
RUN ln -s "$GOPATH/bin/algernon" /usr/bin/algernon

VOLUME /srv/algernon
VOLUME /etc/algernon

RUN chown -R algernon:algernon /srv/algernon /etc/algernon &&\
    setcap 'cap_net_bind_service=+ep' "$GOPATH/bin/algernon"

WORKDIR /srv/algernon

EXPOSE 80

USER algernon

# -c assumes no files will be added or removed, for a slight increase in speed
# --domain makes Algernon look for a folder named the same as the domain it serves
# --server turns off interactive and debug mode
# --cachesize sets a file cache size, in bytes
# --prod makes Algernon serve HTTP on port 80 and HTTPS+HTTP/2 on port 443
# --cert and --key is for setting the HTTPS certificate
#
# Other parameters that might be of interest is "--addr", ":3000" together with
# "--server" but without "--prod" for serving only HTTP on port 3000
#
# "--log", "/var/log/algernon.log" can be used for logging errors
#
# The final parameter is the directory to serve, for instance /srv/algernon
#
CMD ["algernon", "--domain", "--server", "--cachesize", "67108864", "--prod"]
