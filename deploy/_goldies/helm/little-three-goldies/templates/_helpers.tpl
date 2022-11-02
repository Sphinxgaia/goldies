{{/*
Expand the name of the chart.
*/}}
{{- define "little-goldie.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "little-goldie.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "little-goldie.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "little-goldie.labels" -}}
helm.sh/chart: {{ include "little-goldie.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}



{{/*
Selector labels
*/}}
{{- define "little-goldie.main.selectorLabels" -}}
app.kubernetes.io/name: {{ include "little-goldie.name" . }}-main
app.kubernetes.io/instance: {{ .Release.Name }}-main
{{- end }}

{{- define "little-goldie.body.selectorLabels" -}}
app.kubernetes.io/name: {{ include "little-goldie.name" . }}-body
app.kubernetes.io/instance: {{ .Release.Name }}-body
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "little-goldie.main.serviceAccountName" -}}
{{- default (include "little-goldie.fullname" .) .Values.main.serviceAccount.name }}-main
{{- end }}
{{- define "little-goldie.body.serviceAccountName" -}}
{{- default (include "little-goldie.fullname" .) .Values.body.serviceAccount.name }}-body
{{- end }}
