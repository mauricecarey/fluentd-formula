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

{% if "plugins" in fluentd %}
install-plugin-build-tools:
  pkg.installed:
    - pkgs:
      - make
      - {{ fluentd.libcurl }}
    - require:
      - pkg: {{ fluentd.pkg }}

{% for plugin_name in fluentd.plugins %}
install-plugin-{{ plugin_name }}:
  cmd.run:
    - name: /opt/td-agent/embedded/bin/fluent-gem install {{ plugin_name }}
    - unless: /opt/td-agent/embedded/bin/fluent-gem list | grep {{ plugin_name }}
    - require:
      - pkg: {{ fluentd.pkg }}
      - pkg: install-plugin-build-tools
{% endfor %}
{% endif %}

run-fluentd:
  service.running:
    - enable: true
    - name: {{ fluentd.service }}
    - watch:
      - file: /etc/td-agent/td-agent.conf
    - require:
      - pkg: {{ fluentd.pkg }}
