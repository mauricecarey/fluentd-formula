{% from "fluentd/map.jinja" import fluentd with context %}

{% if fluentd.use_upstream_repo %}
include:
  - fluentd.upstream
{% endif %}

install-fluentd:
  pkg.installed:
    - name: {{ fluentd.pkg }}

run-fluentd:
  service.running:
    - enable: true
    - name: {{ fluentd.service }}
    - require:
      - pkg: {{ fluentd.pkg }}
