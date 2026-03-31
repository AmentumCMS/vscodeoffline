{{/*
Expand the name of the chart.
*/}}
{{- define "vscgallery.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this.
*/}}
{{- define "vscgallery.fullname" -}}
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
Create chart label.
*/}}
{{- define "vscgallery.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "vscgallery.labels" -}}
helm.sh/chart: {{ include "vscgallery.chart" . }}
{{ include "vscgallery.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "vscgallery.selectorLabels" -}}
app.kubernetes.io/name: {{ include "vscgallery.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use.
*/}}
{{- define "vscgallery.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "vscgallery.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Gallery container image.
*/}}
{{- define "vscgallery.galleryImage" -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion }}
{{- printf "%s:%s" .Values.image.repository $tag }}
{{- end }}

{{/*
Sync container image.
*/}}
{{- define "vscgallery.syncImage" -}}
{{- $tag := .Values.sync.image.tag | default .Chart.AppVersion }}
{{- printf "%s:%s" .Values.sync.image.repository $tag }}
{{- end }}

{{/*
Name of the artifacts PVC (used both in volumeClaimTemplates and volume references).
*/}}
{{- define "vscgallery.artifactsPvcName" -}}
artifacts
{{- end }}
