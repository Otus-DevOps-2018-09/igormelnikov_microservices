FROM golang:1.11.4
ENV APPHOME /go/src/github.com/percona/mongodb_exporter
WORKDIR $APPHOME
RUN git clone https://github.com/percona/mongodb_exporter $APPHOME
RUN make build


FROM scratch
COPY --from=0 /go/src/github.com/percona/mongodb_exporter/mongodb_exporter /bin/mongodb_exporter
EXPOSE 9216
ENTRYPOINT [ "/bin/mongodb_exporter" ]
