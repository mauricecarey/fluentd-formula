{% from "fluentd/map.jinja" import fluentd with context %}

install-fluentd:
  pkg.installed:
    - name: {{ fluentd.pkg }}

run-fluentd:
  service.running:
    - enable: true
    - name: {{ fluentd.service }}
    - require:
      - pkg: {{ fluentd.pkg }}
