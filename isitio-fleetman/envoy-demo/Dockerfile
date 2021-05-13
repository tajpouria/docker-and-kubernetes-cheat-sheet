FROM envoyproxy/envoy:v1.11.2
RUN apt update
COPY envoy.yaml /etc/envoy.yaml
CMD /usr/local/bin/envoy -c /etc/envoy.yaml
