# FreeSWITCH Exporter for Prometheus

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/mroject/freeswitch_exporter/LICENSE)

A [FreeSWITCH](https://freeswitch.org/confluence/display/FREESWITCH/FreeSWITCH+Explained) exporter for Prometheus.

It communicates with FreeSWITCH using [mod_event_socket](https://freeswitch.org/confluence/display/FREESWITCH/mod_event_socket).

# Cornerstone
Some improvements have been made on the basis of these two projects.

1. [florentchauveau/freeswitch_exporter](https://github.com/florentchauveau/freeswitch_exporter)  
2. [mroject/freeswitch_exporter](https://github.com/mroject/freeswitch_exporter) 


## Getting Started

Pre-built static binaries are available in [releases](https://github.com/mroject/freeswitch_exporter/releases).

docker available in [ghcr.io](https://github.com/mroject/freeswitch_exporter/pkgs/container/freeswitch_exporter)

To run it:
```bash
./freeswitch_exporter [flags]
```

Help on flags:
```
./freeswitch_exporter --help
usage: freeswitch_exporter [<flags>]

Flags:
      --help                   Show context-sensitive help.
  -l, --web.listen-address=":9435"
                               Address to listen on for web interface and telemetry.
      --web.telemetry-path="/metrics"
                               Path under which to expose metrics.
  -u, --freeswitch.scrape-uri="tcp://localhost:8021"
                               URI on which to scrape freeswitch. E.g.
                               "tcp://localhost:8021"
  -t, --freeswitch.timeout=5s  Timeout for trying to get stats from freeswitch.
  -P, --freeswitch.password="ClueCon"
                               Password for freeswitch event socket.
      --web.config=""          [EXPERIMENTAL] Path to config yaml file that can
                               enable TLS or authentication.
      --version                Show application version.
```

## Usage

Make sure [mod_event_socket](https://freeswitch.org/confluence/display/FREESWITCH/mod_event_socket) is enabled on your FreeSWITCH instance. The default mod_event_socket configuration binds to `::` (i.e., to listen to connections from any host), which will work on IPv4 or IPv6. 

You can specify the scrape URI with the `--freeswitch.scrape-uri` flag. Example:

```
./freeswitch_exporter -u "tcp://localhost:8021"
```

Also, you need to make sure that the exporter will be allowed by the ACL (if any), and that the password matches.

## grafana dashboard

import id: **[17071](https://grafana.com/api/dashboards/17071/revisions/1/download)**

## basic auth

build password

```shell
htpasswd -n BC 12 '' |tr -d ':\n'
```

Creating config.yml
Let's create a config.yml file (documentation), with the following content:
```shell
basic_auth_users:
    prometheus: $2a$12$rcRim06GJMX3WUOTDXa.AOwvpWdy.Mrq2nR0Dgo53Zt0bSLpP.byy
```
confg.yaml file password is `prometheus`

You can validate that file with promtool check web-config config.yaml

```shell
$ promtool check web-config config.yaml
config.yaml SUCCESS
```
You can add multiple users to the file.

## TLS 

visit promethues : https://prometheus.io/docs/guides/tls-encryption/

## Prometheus Config:

in prometheus.yml add:
```yaml
  - job_name: "FreeSWITCH"
    static_configs:
      - targets: 
          - 192.168.1.1:9282
```

if freeswitch enable auth（use git  config.yaml）

```
  - job_name: "FreeSWITCH"
    basic_auth:
      username: prometheus
      password: prometheus
    static_configs:
      - targets: 
          - 192.168.1.1:9282
```

## Metrics

The exporter will try to fetch values from the following commands:

- `api show calls count`: Calls count
- `api uptime s`: Uptime
- `api strepoch`: Time synced with system
- `status`
- `sofia xmlstatus gateway`: fetch all gateway
- `module`: usage module.conf.xml fetch all module status
- `api show endpoint` all used endpoint
- `api show codec` all used codec

List of exposed metrics:

```bash
# HELP freeswitch_bridged_calls Number of bridged_calls active
# TYPE freeswitch_bridged_calls gauge
# HELP freeswitch_current_calls Number of calls active
# TYPE freeswitch_current_calls gauge
# HELP freeswitch_current_channels Number of channels active
# TYPE freeswitch_current_channels gauge
# HELP freeswitch_current_idle_cpu CPU idle
# TYPE freeswitch_current_idle_cpu gauge
# HELP freeswitch_current_sessions Number of sessions active
# TYPE freeswitch_current_sessions gauge
# HELP freeswitch_current_sessions_peak Peak sessions since startup
# TYPE freeswitch_current_sessions_peak gauge
# HELP freeswitch_current_sessions_peak_last_5min Peak sessions for the last 5 minutes
# TYPE freeswitch_current_sessions_peak_last_5min gauge
# HELP freeswitch_current_sps Number of sessions per second
# TYPE freeswitch_current_sps gauge
# HELP freeswitch_current_sps_peak Peak sessions per second since startup
# TYPE freeswitch_current_sps_peak gauge
# HELP freeswitch_current_sps_peak_last_5min Peak sessions per second for the last 5 minutes
# TYPE freeswitch_current_sps_peak_last_5min gauge
# HELP freeswitch_detailed_bridged_calls Number of detailed_bridged_calls active
# TYPE freeswitch_detailed_bridged_calls gauge
# HELP freeswitch_detailed_calls Number of detailed_calls active
# TYPE freeswitch_detailed_calls gauge
# HELP freeswitch_exporter_failed_scrapes Number of failed freeswitch scrapes.
# TYPE freeswitch_exporter_failed_scrapes counter
# HELP freeswitch_exporter_total_scrapes Current total freeswitch scrapes.
# TYPE freeswitch_exporter_total_scrapes counter
# HELP freeswitch_load_module freeswitch load module status
# TYPE freeswitch_load_module gauge
# HELP freeswitch_max_sessions Max sessions allowed
# TYPE freeswitch_max_sessions gauge
# HELP freeswitch_max_sps Max sessions per second allowed
# TYPE freeswitch_max_sps gauge
# HELP freeswitch_min_idle_cpu Minimum CPU idle
# TYPE freeswitch_min_idle_cpu gauge
# HELP freeswitch_registrations Number of registrations active
# TYPE freeswitch_registrations gauge
# HELP freeswitch_sessions_total Number of sessions since startup
# TYPE freeswitch_sessions_total counter
# HELP freeswitch_sofia_gateway_call_in freeswitch gateway call-in
# TYPE freeswitch_sofia_gateway_call_in gauge
# HELP freeswitch_sofia_gateway_call_out freeswitch gateway call-out
# TYPE freeswitch_sofia_gateway_call_out gauge
# HELP freeswitch_sofia_gateway_failed_call_in freeswitch gateway failed-call-in
# TYPE freeswitch_sofia_gateway_failed_call_in gauge
# HELP freeswitch_sofia_gateway_failed_call_out freeswitch gateway failed-call-out
# TYPE freeswitch_sofia_gateway_failed_call_out gauge
# HELP freeswitch_sofia_gateway_ping freeswitch gateway ping
# TYPE freeswitch_sofia_gateway_ping gauge
# HELP freeswitch_sofia_gateway_pingcount freeswitch gateway pingcount
# TYPE freeswitch_sofia_gateway_pingcount gauge
# HELP freeswitch_sofia_gateway_pingfreq freeswitch gateway pingfreq
# TYPE freeswitch_sofia_gateway_pingfreq gauge
# HELP freeswitch_sofia_gateway_pingmax freeswitch gateway pingmax
# TYPE freeswitch_sofia_gateway_pingmax gauge
# HELP freeswitch_sofia_gateway_pingmin freeswitch gateway pingmin
# TYPE freeswitch_sofia_gateway_pingmin gauge
# HELP freeswitch_sofia_gateway_pingtime freeswitch gateway pingtime
# TYPE freeswitch_sofia_gateway_pingtime gauge
# HELP freeswitch_sofia_gateway_status freeswitch gateways status
# TYPE freeswitch_sofia_gateway_status gauge
# HELP freeswitch_time_synced Is FreeSWITCH time in sync with exporter host time
# TYPE freeswitch_time_synced gauge
# HELP freeswitch_up Was the last scrape successful.
# TYPE freeswitch_up gauge
# HELP freeswitch_uptime_seconds Uptime in seconds
# TYPE freeswitch_uptime_seconds gauge
# HELP freeswitch_endpoint_status freeswitch endpoint status
# TYPE freeswitch_endpoint_status gauge
# HELP freeswitch_codec_status freeswitch endpoint status
# TYPE freeswitch_codec_status gauge
```

## Compiling

With go 1.18+, clone the project and:

```bash
go build
```

Dependencies will be fetched automatically.

