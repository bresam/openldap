FROM bitnami/openldap:latest

# Add additional schema and ldif files
ADD ldif/disable-bind-anon.ldif \
    ldif/openssh-lpk.ldif \
    ldif/memberof.ldif \
    /opt/bitnami/openldap/etc/schema/
