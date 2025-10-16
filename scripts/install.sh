#!/bin/bash
set -e

# ----------------------------------------------------------------------------------------------
# Install OpenTelemetry Collector
helm repo add opentelemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update
helm upgrade --install otel-collector opentelemetry/opentelemetry-collector \
  --namespace monitoring \
  --set mode=daemonset \
  --set image.repository=otel/opentelemetry-collector-contrib \
  --create-namespace \
  --values otel-values.yaml

# ----------------------------------------------------------------------------------------------
# Install Grafana helm repository

# this one failed
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# this seems to be working
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.28/deploy/local-path-storage.yaml


# in progress
helm install tempo grafana/tempo \
  --namespace monitoring \
  --values tempo-values.yaml

helm upgrade grafana grafana/grafana \
  --namespace monitoring \
  --values grafana-values.yaml

