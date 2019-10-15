{% set p = salt.pillar.get("state01") %}
{% do salt.log.error('state01: ' ~ p) %}