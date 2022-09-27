{{/*
Expand the name of the chart.
*/}}
{{- define "owncloud.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "owncloud.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "owncloud.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "owncloud.labels" -}}
helm.sh/chart: {{ include "owncloud.chart" . }}
{{ include "owncloud.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "owncloud.selectorLabels" -}}
app.kubernetes.io/name: {{ include "owncloud.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "owncloud.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "owncloud.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
ownCloud image logic
*/}}
{{- define "owncloud.image" -}}
  {{- $tag := default .Chart.AppVersion .Values.image.tag -}}
  {{- if $.Values.image.sha -}}
"{{ $.Values.image.repository }}:{{ $tag }}@sha256:{{ $.Values.image.sha }}"
  {{- else -}}
"{{ $.Values.image.repository }}:{{ $tag }}"
  {{- end -}}
{{- end -}}
