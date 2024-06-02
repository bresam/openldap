# bitnami/openldap extended

An extended variant of bitnami/openldap |
[hub.docker.com](https://hub.docker.com/r/bitnami/openldap) |
[github.com](https://github.com/bitnami/containers/tree/main/bitnami/openldap)

**Easy configurable _disable_anon_bind_, _memberOf_ and _openssh-lpk_**

You can find this project on
[github](https://github.com/bresam/openldap) and
[docker hub](https://hub.docker.com/r/bresam/openldap)

---

## Changes

 - Additional ldif config files which can be used (executed) by ENV variable:
   - disable anonymous bind (login/read)
   - [openldap-memberof-overlay](https://tylersguides.com/guides/openldap-memberof-overlay/)
   - [openssh-lpk](https://openssh-ldap-pubkey.readthedocs.io/en/latest/openldap.html)

## ENV config

For general configurations and usage instructions have a look at the [bitnami openldap documentation](https://hub.docker.com/r/bitnami/openldap)

 - `LDAP_EXTRA_SCHEMAS`:   
    Bitnami's default config is: _"cosine,inetorgperson,nis"_   
    - Disable anonymous bind `disable-bind-anon`   
      `LDAP_EXTRA_SCHEMAS="cosine,inetorgperson,nis,disable-bind-anon"`
    - Add `openssh-lpk`   
      `LDAP_EXTRA_SCHEMAS="cosine,inetorgperson,nis,openssh-lpk"`
    - Add `memberof`   
      `LDAP_EXTRA_SCHEMAS="cosine,inetorgperson,nis,memberof"`   
      Groups created before (like `readers` created by default schema)
      need to be deleted and recreated before the memberof overlay takes into action

## Playground

By docker compose we start an `openldap` and `phpldapadmin` containers.   
PhpLdapAdmin has a preconfigured connection to the ldap server, the default password is `admin`.   
VIRTUAL_HOST is configured to [http://ldap.test](http://ldap.test) or just use the mapped port [http://localhost:8080](http://localhost:8080)

Have a look or edit config in [docker-compose.yaml](./docker-compose.yaml)

```bash
# start environment
docker compose up -d --build
```

```bash
# restart environment after config changes
docker compose down && docker compose up -d --build
```

### PhpLdapAdmin

Preconfigured connections:
 - **1 openldap-extended (unsecure)**: non-tls connection
 - **2 openldap-extended (tls)**: not used yet, needs tls config on server
 - **3 openldap-bitnami (unsecure)**: non-tls connection
 - **4 openldap-bitnami (tls)**: not used yet, needs tls config on server

### Connect with other ldap clients from localhost

Bind DN: `cn=admin,dc=example,dc=com`
Password: `admin`

Container ports of ldap services are bound to localhost by default
and can be accessed with any locally installed ldap client:
- openldap-extended
   - unsecure: `localhost:1389`
   - secure (tls): `localhost:1636` not used yet, needs tls config on server
- openldap-bitnami
   - unsecure: `localhost:2389`
   - secure (tls): `localhost:2636` not used yet, needs tls config on server

## Notes

**You don't need any of these, but possibly it could help on future debugging stuff**

```bash
docker compose down && docker volume prune -f && docker compose up -d --build
```

```bash
ldapadd -Y EXTERNAL -H "ldapi:///" -f "/opt/bitnami/openldap/etc/schema/disable-bind-anon.ldif"
ldapadd -Y EXTERNAL -H "ldapi:///" -f "/opt/bitnami/openldap/etc/schema/openssh-lpk.ldif"
ldapadd -Y EXTERNAL -H "ldapi:///" -f "/opt/bitnami/openldap/etc/schema/memberof.ldif"
```

```bash
ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b cn=config dn
```

### memberOf

https://technicalnotes.wordpress.com/2014/04/19/openldap-setup-with-memberof-overlay/

https://www.adimian.com/blog/how-to-enable-memberof-using-openldap/
