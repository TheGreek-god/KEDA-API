# Kubernetes Autoscaling with Node.js API, K6 Load Testing, and Monitoring

This project demonstrates a complete autoscaling setup for a Node.js API using Kubernetes, K6 for load testing, Prometheus/Grafana for monitoring, and KEDA for event-driven autoscaling.

# Project Overview

This project provides a comprehensive example of implementing autoscaling for a Node.js API in Kubernetes using the following technologies:

- **Node.js API (myidentity-api)**: A sample application to demonstrate the API functionality.
- **K6 Load Testing**: A performance testing framework to simulate real-world traffic and assess the scalability of the API.
- **Prometheus**: A system for collecting and storing metrics from the Node.js API and Kubernetes clusters.
- **Grafana**: A visualization dashboard for monitoring and analyzing performance metrics.
- **KEDA (Kubernetes Event-Driven Autoscaling)**: A system for event-driven autoscaling of the Node.js API based on real-time metrics.
- **InfluxDB**: A time-series database for storing and managing K6 test metrics.

## 🛠️ Prerequisites

- **Docker Desktop** with Kubernetes enabled **OR** **Minikube**
- **kubectl** command-line tool
- **Docker** (for building images)
- **Helm** (optional, for easier KEDA installation)

## 🚀 Quick Start

### 1. Start Minikube (if using Minikube)

```bash
minikube start --memory=4096 --cpus=4
```
### 2. Build and Deploy Everything
```bash
# 1. Build Docker image
docker build -t yourname/myidentity-api:latest .

# 2. Load into Minikube (if using Minikube)
minikube image load yourname/myidentity-api:latest

# 3. Deploy k8s stack
kubectl apply -f k8s/

# 4. Deploy your API
kubectl apply -f deploy/

# 5. Deploy KEDA
kubectl apply -f https://github.com/kedacore/keda/releases/download/v2.10.1/keda-2.10.1.yaml

# 6. Deploy autoscaling config
kubectl apply -f keda/
```
## 📊 Access Services

After deployment, access the services:

```bash
# Get all service URLs
minikube service list

# Access specific services
minikube service myidentity-service -n api-app --url
minikube service grafana-service -n monitoring --url
minikube service prometheus-service -n monitoring --url

# Or use port forwarding
kubectl port-forward svc/myidentity-service -n api-app 4000:4000
kubectl port-forward svc/grafana-service -n monitoring 3000:3000
kubectl port-forward svc/grafana-service -n monitoring 9090:9090
```
### 🔗 Default URLs

- **MyIdentity API**: http://localhost:4000/crocodiles  
- **Grafana**: http://localhost:3000  
  - Credentials: `admin / admin`
- **Prometheus**: http://localhost:9090
- **API Metrics**: http://localhost:4000/metrics

## 🏃‍♂️ Running Load Tests

### 1. Create K6 Job

```bash
kubectl apply -f k8s/k6-job.yaml
```
### 2. Monitor Test
```bash
# Watch job status
kubectl get jobs -n performance-test -w

# View logs
kubectl logs -n performance-test -f job/k6-loadtest
```
### 3. View Results in Grafana

1. **Add InfluxDB datasource** in Grafana  
   - **URL**: http://influxdb-service.influxdb.svc.cluster.local:8086  
   - **Database**: `k6`

2. **Import K6 Dashboard**  
   - Dashboard ID: **2587**

### 4. Import Crocodile Metrics Dashboard

Create a new dashboard in Grafana by importing the **My-Identity Metrics Dashboard** to visualize application-specific metrics.
```bash
{
  "__inputs": [
    {
      "name": "DS_PROMETHEUS",
      "label": "Prometheus",
      "description": "",
      "type": "datasource",
      "pluginId": "prometheus",
      "pluginName": "Prometheus"
    },
    {
      "name": "DS_INFLUXDB-K6",
      "label": "InfluxDB-K6",
      "description": "",
      "type": "datasource",
      "pluginId": "influxdb",
      "pluginName": "InfluxDB"
    }
  ],
  "__requires": [
    {
      "type": "panel",
      "id": "bargauge",
      "name": "Bar Gauge",
      "version": ""
    },
    {
      "type": "panel",
      "id": "gauge",
      "name": "Gauge",
      "version": ""
    },
    {
      "type": "grafana",
      "id": "grafana",
      "name": "Grafana",
      "version": "6.7.3"
    },
    {
      "type": "panel",
      "id": "graph",
      "name": "Graph",
      "version": ""
    },
    {
      "type": "datasource",
      "id": "influxdb",
      "name": "InfluxDB",
      "version": "1.0.0"
    },
    {
      "type": "datasource",
      "id": "prometheus",
      "name": "Prometheus",
      "version": "1.0.0"
    }
  ],
  "annotations": {
    "list": [
      {
        "$$hashKey": "object:155",
        "builtIn": 1,
        "datasource": "-- Grafana --",
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "type": "dashboard"
      }
    ]
  },
  "editable": true,
  "gnetId": null,
  "graphTooltip": 0,
  "id": null,
  "iteration": 1589906489073,
  "links": [],
  "panels": [
    {
      "collapsed": false,
      "datasource": "${DS_PROMETHEUS}",
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 0
      },
      "id": 12,
      "panels": [],
      "title": "K6 InfluxDB Metrics",
      "type": "row"
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "${DS_INFLUXDB-K6}",
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 7,
        "w": 11,
        "x": 0,
        "y": 1
      },
      "hiddenSeries": false,
      "id": 10,
      "interval": "1s",
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": false,
        "max": true,
        "min": false,
        "rightSide": false,
        "show": true,
        "total": false,
        "values": true
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "connected",
      "options": {
        "dataLinks": []
      },
      "percentage": false,
      "pointradius": 1,
      "points": true,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "alias": "Requests per Second",
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "$__interval"
              ],
              "type": "time"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "http_reqs",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "A",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "value"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "sum"
              }
            ]
          ],
          "tags": []
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Requests per Second",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        },
        {
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": true,
      "dashLength": 10,
      "dashes": false,
      "datasource": "${DS_INFLUXDB-K6}",
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 7,
        "w": 11,
        "x": 11,
        "y": 1
      },
      "hiddenSeries": false,
      "id": 8,
      "interval": ">1s",
      "legend": {
        "alignAsTable": true,
        "avg": false,
        "current": true,
        "max": true,
        "min": false,
        "show": true,
        "total": false,
        "values": true
      },
      "lines": false,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "options": {
        "dataLinks": []
      },
      "percentage": false,
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "alias": "Active VUs",
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "$__interval"
              ],
              "type": "time"
            },
            {
              "params": [
                "none"
              ],
              "type": "fill"
            }
          ],
          "measurement": "vus",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "A",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "value"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              }
            ]
          ],
          "tags": []
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Virtual Users",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:228",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        },
        {
          "$$hashKey": "object:229",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "collapsed": false,
      "datasource": "${DS_PROMETHEUS}",
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 8
      },
      "id": 14,
      "panels": [],
      "title": "My-Identity Prometheus Metrics",
      "type": "row"
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "${DS_PROMETHEUS}",
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 6,
        "w": 11,
        "x": 0,
        "y": 9
      },
      "hiddenSeries": false,
      "id": 16,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null",
      "options": {
        "dataLinks": []
      },
      "percentage": false,
      "pluginVersion": "6.7.3",
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "count(up{job=\"myidentity-api\"})",
          "instant": false,
          "interval": "",
          "legendFormat": "Running Pods",
          "refId": "A"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Running Pods",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:662",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "$$hashKey": "object:663",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "datasource": "${DS_PROMETHEUS}",
      "gridPos": {
        "h": 6,
        "w": 11,
        "x": 11,
        "y": 9
      },
      "id": 29,
      "options": {
        "displayMode": "lcd",
        "fieldOptions": {
          "calcs": [
            "last"
          ],
          "defaults": {
            "mappings": [],
            "max": 1,
            "min": 0,
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "#7EB26D",
                  "value": 0
                }
              ]
            },
            "unit": "short"
          },
          "overrides": [
            {
              "matcher": {
                "id": "byName",
                "options": "Running"
              },
              "properties": [
                {
                  "id": "color",
                  "value": {
                    "fixedColor": "#7EB26D",
                    "mode": "fixed"
                  }
                }
              ]
            },
            {
              "matcher": {
                "id": "byName",
                "options": "Pending"
              },
              "properties": [
                {
                  "id": "color",
                  "value": {
                    "fixedColor": "#EAB839",
                    "mode": "fixed"
                  }
                }
              ]
            },
            {
              "matcher": {
                "id": "byName",
                "options": "Failed"
              },
              "properties": [
                {
                  "id": "color",
                  "value": {
                    "fixedColor": "#E02F44",
                    "mode": "fixed"
                  }
                }
              ]
            }
          ],
          "values": false
        },
        "orientation": "vertical",
        "showUnfilled": true
      },
      "pluginVersion": "6.7.3",
      "targets": [
        {
          "expr": "count(up{job=\"myidentity-api\"})",
          "instant": true,
          "interval": "",
          "legendFormat": "Running",
          "refId": "A"
        },
        {
          "expr": "0",
          "instant": true,
          "interval": "",
          "legendFormat": "Pending",
          "refId": "B"
        },
        {
          "expr": "0",
          "instant": true,
          "interval": "",
          "legendFormat": "Failed",
          "refId": "C"
        }
      ],
      "timeFrom": null,
      "timeShift": null,
      "title": "Pod Status",
      "type": "bargauge"
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "${DS_PROMETHEUS}",
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 9,
        "w": 7,
        "x": 0,
        "y": 15
      },
      "hiddenSeries": false,
      "id": 4,
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": true,
        "hideEmpty": true,
        "hideZero": true,
        "max": true,
        "min": false,
        "rightSide": false,
        "show": true,
        "total": false,
        "values": true
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null",
      "options": {
        "dataLinks": []
      },
      "percentage": false,
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "rate(node_http_requests_total{status=\"200\"}[2m])",
          "instant": false,
          "interval": "",
          "legendFormat": "{{instance}}",
          "refId": "A"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "HTTP Request Rate/Second",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:410",
          "format": "short",
          "label": "Rate",
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "$$hashKey": "object:411",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "${DS_PROMETHEUS}",
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 9,
        "w": 6,
        "x": 7,
        "y": 15
      },
      "hiddenSeries": false,
      "id": 6,
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": true,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": true
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null",
      "options": {
        "dataLinks": []
      },
      "percentage": false,
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "node_http_duration_seconds{quantile=\"0.99\"} * 1000",
          "interval": "",
          "legendFormat": "{{instance}}",
          "refId": "A"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Response Time - 0.99 Percentile (ms)",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:147",
          "format": "ms",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "$$hashKey": "object:148",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "${DS_PROMETHEUS}",
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 9,
        "w": 9,
        "x": 13,
        "y": 15
      },
      "hiddenSeries": false,
      "id": 28,
      "legend": {
        "alignAsTable": true,
        "avg": false,
        "current": true,
        "hideEmpty": true,
        "hideZero": true,
        "max": true,
        "min": false,
        "rightSide": true,
        "show": true,
        "sort": "avg",
        "sortDesc": true,
        "total": false,
        "values": true
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "options": {
        "dataLinks": []
      },
      "percentage": false,
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "nodejs_heap_size_used_bytes",
          "format": "time_series",
          "interval": "",
          "intervalFactor": 2,
          "legendFormat": "Memory Used",
          "refId": "A",
          "step": 2
        },
        {
          "expr": "nodejs_heap_size_total_bytes",
          "format": "time_series",
          "interval": "",
          "intervalFactor": 2,
          "legendFormat": "Total Heap",
          "refId": "B",
          "step": 2
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Node.js Memory Usage",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:89",
          "format": "bytes",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        },
        {
          "$$hashKey": "object:90",
          "decimals": null,
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": true,
        "alignLevel": null
      }
    },
    {
      "collapsed": true,
      "datasource": "${DS_PROMETHEUS}",
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 24
      },
      "id": 31,
      "panels": [
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": "${DS_INFLUXDB-K6}",
          "fill": 0,
          "fillGradient": 0,
          "gridPos": {
            "h": 7,
            "w": 6,
            "x": 0,
            "y": 26
          },
          "hiddenSeries": false,
          "id": 24,
          "interval": ">1s",
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": false,
            "max": false,
            "min": false,
            "show": true,
            "total": true,
            "values": true
          },
          "lines": true,
          "linewidth": 1,
          "links": [],
          "nullPointMode": "null",
          "options": {
            "dataLinks": []
          },
          "percentage": false,
          "pointradius": 0.5,
          "points": true,
          "renderer": "flot",
          "seriesOverrides": [
            {
              "alias": "Num Errors",
              "color": "#BF1B00"
            }
          ],
          "spaceLength": 10,
          "stack": true,
          "steppedLine": false,
          "targets": [
            {
              "alias": "$tag_check",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "$__interval"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "check"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "none"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "checks",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "C",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "value"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "sum"
                  }
                ]
              ],
              "tags": []
            }
          ],
          "thresholds": [],
          "timeFrom": null,
          "timeRegions": [],
          "timeShift": null,
          "title": "Checks Per Second",
          "tooltip": {
            "shared": true,
            "sort": 0,
            "value_type": "individual"
          },
          "type": "graph",
          "xaxis": {
            "buckets": null,
            "mode": "time",
            "name": null,
            "show": true,
            "values": []
          },
          "yaxes": [
            {
              "format": "none",
              "label": null,
              "logBase": 1,
              "max": null,
              "min": null,
              "show": true
            },
            {
              "format": "short",
              "label": null,
              "logBase": 1,
              "max": null,
              "min": null,
              "show": true
            }
          ],
          "yaxis": {
            "align": false,
            "alignLevel": null
          }
        },
        {
          "datasource": "${DS_PROMETHEUS}",
          "gridPos": {
            "h": 7,
            "w": 4,
            "x": 6,
            "y": 26
          },
          "id": 2,
          "options": {
            "fieldOptions": {
              "calcs": [
                "last"
              ],
              "defaults": {
                "links": [],
                "mappings": [],
                "max": 10,
                "min": 0,
                "thresholds": {
                  "mode": "absolute",
                  "steps": [
                    {
                      "color": "#E02F44",
                      "value": 0
                    },
                    {
                      "color": "#EAB839",
                      "value": 0.5
                    },
                    {
                      "color": "#7EB26D",
                      "value": 1
                    }
                  ]
                },
                "title": "Pods",
                "unit": "short"
              },
              "overrides": [],
              "values": false
            },
            "orientation": "auto",
            "showThresholdLabels": false,
            "showThresholdMarkers": true
          },
          "pluginVersion": "6.7.3",
          "targets": [
            {
              "expr": "count(up{job=\"myidentity-api\"})",
              "instant": false,
              "interval": "",
              "legendFormat": "",
              "refId": "A"
            }
          ],
          "timeFrom": null,
          "timeShift": null,
          "title": "Total My-Identity Pods",
          "type": "gauge"
        }
      ],
      "title": "Archived",
      "type": "row"
    }
  ],
  "refresh": "5s",
  "schemaVersion": 22,
  "style": "dark",
  "tags": [],
  "templating": {
    "list": [
      {
        "allValue": null,
        "current": {
          "text": "api-app",
          "value": "api-app"
        },
        "datasource": "${DS_PROMETHEUS}",
        "definition": "label_values(up, namespace)",
        "hide": 0,
        "includeAll": false,
        "index": -1,
        "label": "Namespace",
        "multi": false,
        "name": "namespace",
        "options": [],
        "query": "label_values(up, namespace)",
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 1,
        "tagValuesQuery": "",
        "tags": [],
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "allValue": null,
        "current": {
          "text": "myidentity-api",
          "value": "myidentity-api"
        },
        "datasource": "${DS_PROMETHEUS}",
        "definition": "label_values(up{namespace=\"$namespace\"}, job)",
        "hide": 0,
        "includeAll": false,
        "index": -1,
        "label": "Job",
        "multi": false,
        "name": "job",
        "options": [],
        "query": "label_values(up{namespace=\"$namespace\"}, job)",
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 1,
        "tagValuesQuery": "",
        "tags": [],
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      }
    ]
  },
  "time": {
    "from": "now-30m",
    "to": "now"
  },
  "timepicker": {
    "refresh_intervals": [
      "1s",
      "5s",
      "10s",
      "30s",
      "1m",
      "5m",
      "15m",
      "30m",
      "1h",
      "2h",
      "1d"
    ]
  },
  "timezone": "",
  "title": "My-Identity Metrics Dashboard",
  "uid": "n1copReWk",
  "variables": {
    "list": []
  },
  "version": 46
}
```

## ✅ Verification Commands

```bash
# Check all components
kubectl get pods -A

# Check autoscaling status
kubectl get scaledobject -A
kubectl get hpa -A

# Check services
kubectl get services -A

# Monitor scaling in real-time
kubectl get pods -n api-app -w
kubectl get hpa -n api-app -w
```
