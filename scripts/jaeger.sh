#!/bin/bash

echo "Installing Jaeger in monitoring namespace..."

# Add Jaeger Helm repository
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update

# Install Jaeger with custom values
helm upgrade --install jaeger jaegertracing/jaeger \
  --namespace monitoring \
  --values ../shared-services/monitoring/jaeger/values.yaml \
  --wait

echo "Jaeger installation completed!"
echo "To access Jaeger UI:"
echo "kubectl port-forward -n monitoring service/jaeger-query 16686:16686"
