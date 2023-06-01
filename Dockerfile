# build
FROM golang:1.18 as builder

WORKDIR /go/src
COPY . /go/src/
RUN CGO_ENABLED=0 go build -a -o freeswitch_exporter

# run
FROM scratch

COPY --from=builder /go/src/freeswitch_exporter /freeswitch_exporter

EXPOSE 9435
ENTRYPOINT [ "/freeswitch_exporter" ]
