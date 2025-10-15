#!/bin/bash
set -e

# ----------------------------------------------------------------------------------------------
# todo: delete or fix
# kubernetes-dashboard repository
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
# Deploy a Helm Release named "kubernetes-dashboard" using the kubernetes-dashboard chart
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard

# ----------------------------------------------------------------------------------------------
# Cert-Manager (required for OpenTelemetry Operator)
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true

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
# Add Jaeger repository
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update
helm install jaeger jaegertracing/jaeger \
  --namespace tracing \
  --values jaeger-values.yaml


# ----------------------------------------------------------------------------------------------
# Add the prometheus-community Helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus \
  --namespace monitoring \
  --values prometheus-values.yaml

