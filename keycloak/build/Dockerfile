FROM quay.io/keycloak/keycloak:23.0.3 AS builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure a database vendor
ENV KC_DB=dev-mem
ENV KC_DB_URL="jdbc:h2:mem:db_name_test;AUTO_SERVER=TRUE"
ENV KC_DB_USERNAME=root
ENV KC_DB_PASSWORD=root

# Configure default domain
ENV KC_HOSTNAME=localhost.domain

WORKDIR /opt/keycloak

ENTRYPOINT ["/app/entrypoint.sh"]