FROM alpine:3.7 AS installer
RUN apk --no-cache add --update wget

# Install open-policy-agent/opa
ENV OPA_VERSION=v0.24.0
RUN mkdir -p /tmp/opa \
    && wget -O /tmp/opa/opa_linux_amd64 https://github.com/open-policy-agent/opa/releases/download/${OPA_VERSION}/opa_linux_amd64 \
    && chmod 755 /tmp/opa/opa_linux_amd64


FROM alpine:3.7
COPY --from=installer /tmp/opa/opa_linux_amd64 /usr/local/bin/opa
RUN opa version

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
