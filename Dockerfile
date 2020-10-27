FROM alpine:3.7 AS installer
RUN apk --no-cache add --update wget coreutils

# Install open-policy-agent/opa
ENV OPA_VERSION=v0.24.0
RUN mkdir -p /tmp/opa \
    && wget -O /tmp/opa/opa_linux_amd64 https://github.com/open-policy-agent/opa/releases/download/${OPA_VERSION}/opa_linux_amd64 \
    && chmod 755 /tmp/opa/opa_linux_amd64
RUN mkdir -p /tmp/yaml2json \
    && wget -O /tmp/yaml2json/yaml2json-linux-amd64 https://github.com/wakeful/yaml2json/releases/latest/download/yaml2json-linux-amd64 \
    && chmod +x /tmp/yaml2json/yaml2json-linux-amd64

FROM alpine:3.7
COPY --from=installer /tmp/opa/opa_linux_amd64 /usr/local/bin/opa
COPY --from=installer /tmp/yaml2json/yaml2json-linux-amd64 /usr/local/bin/yaml2json

COPY --from=installer /usr/bin/coreutils /usr/bin/coreutils

RUN opa version

# DEBUG - ensure tools are installed -
RUN csplit --help
RUN yaml2json --help

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
