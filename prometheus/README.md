# Prometheus Examples

[Curriculum](https://github.com/in4it/prometheus-course)

## Introduction

- Install the Prometheus.
- Install the Grafana.
- Install [Node Exporter](https://github.com/prometheus/node_exporter) and add it as target.
- Install [WMI Exporter](https://github.com/prometheus-community/windows_exporter) and add it as target.

## Monitoring

- Implement a HTTP server using [client_python](https://github.com/prometheus/client_python) library, register it as target and expose following metrics:
  - Counter: Total count of the requests.
  - Gauge: The number of in progress requests. (Use a dummy delay to observe this)
  - Histogram: The request latencies.
