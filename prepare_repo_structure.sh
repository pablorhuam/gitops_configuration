#!/bin/bash

# Define the base directory
mkdir -p base/templates

# Create a sample deployment template in the base directory
cat <<EOF > base/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.name }}
spec:
  replicas: {{ .Values.replicas }}
  template:
    metadata:
      labels:
        app: {{ .Values.name }}
    spec:
      containers:
        - name: {{ .Values.name }}
          image: {{ .Values.image }}
          ports:
            - containerPort: {{ .Values.port }}
EOF

# Create a sample values file in the base directory
cat <<EOF > base/values.yaml
name: my-app
replicas: 1
image: my-app:latest
port: 80
EOF

# Define the variants directory
mkdir -p variants

# Create a production variant values file
cat <<EOF > variants/production.yaml
replicas: 3
image: my-app:stable
EOF

# Create a staging variant values file
cat <<EOF > variants/staging.yaml
replicas: 2
image: my-app:staging
EOF

# Create a development variant values file
cat <<EOF > variants/development.yaml
replicas: 1
image: my-app:dev
EOF

# Define the environments directory
mkdir -p environments

# Create environment directories and corresponding values files
for env in production staging development; do
  mkdir -p environments/$env
  cat <<EOF > environments/$env/values.yaml
# Import base values
{{- include "base.values.yaml" . | nindent 0 }}

# Override with environment-specific values
{{- include "variants/$env.yaml" . | nindent 0 }}
EOF
done

echo "Directory structure created successfully."

