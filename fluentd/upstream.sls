{% from "fluentd/map.jinja" import fluentd with context %}

{% if grains['os_family'] == 'Debian' %}
install-fluentd-repo:
  pkgrepo.managed:
    - humanname: fluentd repository
    - name: {{ fluentd.pkg_repo }}
    - file: {{ fluentd.pkg_repo_file }}
    - require_in:
      - pkg: {{ fluentd.pkg }}
{% endif %}
