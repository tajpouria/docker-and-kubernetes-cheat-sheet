# Prometheus Examples

[Curriculum](https://github.com/in4it/prometheus-course)

## [Introduction](00-introduction)

- Install the Prometheus.
- Install the Grafana.
- Install [Node Exporter](https://github.com/prometheus/node_exporter) and add it as target.
- Install [WMI Exporter](https://github.com/prometheus-community/windows_exporter) and add it as target.

## [Monitoring](01-monitoring)

- Implement a HTTP server using [client_python](https://github.com/prometheus/client_python) library, register it as target and expose following metrics:
  - Counter: Total count of the requests.
  - Gauge: The number of in progress requests. (Use a dummy delay to observe this)
  - Histogram: The request latencies.
- Configure a [push gateway](https://github.com/prometheus/pushgateway), register it as target and write a python cron job that pushes the following metric.
  - Counter: The total amount of seconds took to operate its job. (Use a dummy delay to simulate this)
