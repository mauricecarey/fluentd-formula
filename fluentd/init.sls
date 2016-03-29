{% from "fluentd/map.jinja" import fluentd with context %}

{% if fluentd.use_upstream_repo %}
include:
  - fluentd.upstream
{% endif %}

install-fluentd:
  pkg.installed:
    - name: {{ fluentd.pkg }}
    - refresh: {{ fluentd.use_upstream_repo }}

{% if "config_file" in fluentd %}
fluentd-config:
  file.managed:
    - name: /etc/td-agent/td-agent.conf
    - source: {{ fluentd.config_file }}
    - template: jinja
    - mode: 644
    - user: root
{% endif %}

run-fluentd:
  service.running:
    - enable: true
    - name: {{ fluentd.service }}
    - watch:
      - file: /etc/td-agent/td-agent.conf
    - require:
      - pkg: {{ fluentd.pkg }}
