FROM ghcr.io/herodevs/eol-scan:latest

USER root
RUN microdnf install -y hostname && microdnf clean all

COPY --chmod=755 entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]