---
title: "SAML Authentication"
date: "2025-07-09"
description:
categories:
pageintoc: "126"
tags:
weight: "5"
---

<a id="saml"></a>

<!--# SAML Authentication -->

The SAML Authentication driver allows users to access OpenNebula by logging in into a trusted SAML Identity Provider, effectively centralizing authentication and allowing Single Sign-On. Enabling it allows OpenNebula to be used as a SAML Service Provider.

## Requirements

You need to manage your own SAML Identity Provider. OpenNebula doesn’t contain or configure any SAML Identity Provider, it only receives SAML responses and validates those.

## Configuration

This authentication mechanism is enabled by default. If it doesn’t work, make sure you have the authentication method `saml` enabled in the `AUTH_MAD` section of your [/etc/one/oned.conf]({{% relref "../../operation_references/opennebula_services_configuration/oned#oned-conf" %}}). For example:

```default
AUTH_MAD = [
    EXECUTABLE = "one_auth_mad",
    AUTHN = "ssh,x509,ldap,server_cipher,server_x509,saml"
]
```

The `AUTH_MAD_CONF`section relative to `saml` should also be present in [/etc/one/oned.conf]({{% relref "../../operation_references/opennebula_services_configuration/oned#oned-conf" %}}):

```default
AUTH_MAD_CONF = [
    NAME = "saml",
    PASSWORD_CHANGE = "YES",
    PASSWORD_REQUIRED = "NO",
    DRIVER_MANAGED_GROUPS = "YES",
    DRIVER_MANAGED_GROUP_ADMIN = "YES",
    MAX_TOKEN_TIME = "86400"
]
```

The `saml` authentication driver can be configured in `/etc/one/auth/saml_auth.conf`. This is the default configuration:

```yaml
# -------------------------------------------------------------------------- #
# Global Service Provider (SP) Configuration                                 #
# -------------------------------------------------------------------------- #
# The unique identifier for this OpenNebula instance as a Service Provider.
# This exact value must be configured in each Identity Provider (IdP) that
# you connect (e.g., as the Client ID in Keycloak or Audience URI in Okta).
# It is used to validate the 'Audience' in the SAML assertion.
:sp_entity_id: 'your-opennebula-sp-entity-id'

# -------------------------------------------------------------------------- #
# Assertion Consumer Service (ACS) URL                                       #
# -------------------------------------------------------------------------- #
# The endpoint where OpenNebula receives SAML assertions.
# This value must exactly match the 'Recipient' URL that the IdP
# includes in the SAML assertion, preventing SAML redirect attacks
:acs_url: 'https://your-opennebula-domain.com/fireedge/api/auth/acs'

# -------------------------------------------------------------------------- #
# Identity Provider (IdP) Definitions                                        #
# -------------------------------------------------------------------------- #
# A map containing the configuration for each trusted Identity Provider,
# where the key is the name of the provider.
:identity_providers:
  :keycloak_idp:
    # The 'issuer' is a unique identifier for the Identity Provider.
    # This value from the SAML assertion's <saml:Issuer> element is used
    # to find the correct configuration block.
    # Example: "https://your-keycloak-domain.com/realms/your-realm"
    :issuer: 'https://your-keycloak-domain.com/realms/your-realm'

    # The X.509 public key certificate of the Identity Provider.
    # This is used to verify the signature of the SAML assertion.
    # The certificate should be in PEM format, without the -----BEGIN...
    # and -----END... lines, and on a single line.
    :idp_cert: 'MIID...your...IdP...cert...here...A=='

    # Field in the SAML assertion that contains the username.
    # By default, the driver will use the content of the <saml:NameID> element.
    :user_field: 'NameID'

    # Field in the SAML assertion that contains the group membership information.
    # This should correspond to an <saml:Attribute> with the Name specified here.
    # Default is 'member'.
    :group_field: 'member'

    # If set, SAML users must belong to this group in order to be allowed access to
    # OpenNebula. If not set, any valid SAML user will be granted access. If that's
    # the case and no group membership is reported, the ONE group ID defined in
    # :mapping_default will be used.
    # :group_required: 'one-users'

    # --- Group Mapping Configuration ---

    # If 'true', the driver will automatically generate a group mapping file
    # from the information in the OpenNebula groups template. This is similar to the
    # LDAP driver's functionality.
    :mapping_generate: true

    # Key from the OpenNebula group template to map to a SAML group.
    # Only relevant if mapping_generate is true
    :mapping_key: 'SAML_GROUP'

    # Group mapping mode. Triggers IDP-dependant logic.
    # Used to support specific IDP features (e.g. group nesting in Keycloak)
    # Possible values:
    # strict   => strict mapping between the group names reported by the IdP and
    #             the ones in the mapping file.
    # keycloak => handles Keycloak full group path syntax, supporting group nesting
    #             E.g. A user member of /group1/subgroup1 is considered both member
    #                  of group1 and member of subgroup1.
    :mapping_mode: 'keycloak'

    # Time in seconds that a mapping file will be considered valid before
    # it is regenerated. Only relevant if mapping_generate is true
    :mapping_timeout: 300

    # The name of the group mapping file, which will be stored in
    # OpenNebula's var directory ( /var/lib/one ).
    # If mapping_generate is true, this file will be automatically created and
    # populated.
    :mapping_filename: 'keycloak_groups.yaml'

    # The default OpenNebula group ID to assign to a user if none of their SAML
    # groups is found in the mapping file.
    :mapping_default: 1

    # Name of a group from the Identity Provider. If a user is a member of this group,
    # they will be granted admin rights for ALL their mapped OpenNebula groups.
    :group_admin_name: '/opennebula-admins'
  :okta_idp:
    :issuer: 'https://your-okta-domain.com/app/your-app-id/sso/saml'
    :idp_cert: 'MIID...your...IdP...cert...here...A=='
    :user_field: 'NameID'
    :group_field: 'member'
    # :group_required: 'opennebula-users'
    :mapping_generate: true
    :mapping_key: 'OKTA_GROUP'
    :mapping_mode: 'strict'
    :mapping_timeout: 300
    :mapping_filename: 'okta_groups.yaml'
    :mapping_default: 1
    :group_admin_name: 'okta-opennebula-admins'
```
Each one of the configuration parameters is explained in the file itself through comments. The SAML authentication driver supports the definition of several trusted Identity Providers through the `:identity_providers` hash.

OpenNebula can be also configured to enable external SAML authentication for all new users by adding this line in [/etc/one/oned.conf]({{% relref "../../operation_references/opennebula_services_configuration/oned#oned-conf" %}}):

```default
DEFAULT_AUTH = "saml"
```

This will avoid cloud admins having to manually create users with the SAML authentication driver. If DEFAULT_AUTH is set to "saml", successfully authenticated users that are not present in the OpenNebula database will be automatically provisioned.


## Group Mapping

SAML Identity Providers can usually be configured to report group membership to the Service Provider (see below for configuration samples with Keycloak and Okta). The name of the attribute included in the SAML assertion to report group membership is not defined in the SAML standard and is usually something configurable (typical values are `member` and `memberOf`). OpenNebula will expect group membership to be reported as the attribute defined in `:group_field`.

The groups reported by the Identity Provider are mapped to OpenNebula groups through a mapping file. The name of this mapping file is specified by the `:mapping_filename` parameter and resides in the OpenNebula `var` directory. The mapping file can be generated automatically using data in the OpenNebula group template. For example, we can add this line in the OpenNebula group template:

```default
SAML_GROUP="technicians"
```

and in the SAML configuration file we set the `:mapping_key` to `SAML_GROUP`. This tells the driver to look for the SAML group specified in that template parameter. This mapping expires after the number of seconds specified by `:mapping_timeout`. This is done so that the authentication driver is not continuously querying OpenNebula.

The automatic generation of this mapping file can also be disabled through the `:mapping_generate` configuration parameter. In this case, the group mapping will need to be defined manually. The mapping file is in YAML format and contains a hash where the key is the name of the group reported by the IdP and the value is the ID of the OpenNebula group. For example:

```yaml
---
technicians: '100'
users: '101'

```

When several Identity Providers are configured, you should have different `:mapping_key` and `:mapping_filename` values for each one so they don’t collide. For example:

```yaml
keycloak:
    :mapping_filename: keycloak_group_mapping.yaml
    :mapping_key: KEYCLOAK_GROUP

okta:
    :mapping_filename: okta_group_mapping.yaml
    :mapping_key: OKTA_GROUP
```

and in the OpenNebula group template you can define two mappings, one for each Identity Provider:

```default
KEYCLOAK_GROUP="one-users"
OKTA_GROUP="group1"
```
{{< alert title="Note" color="success" >}}
If a user has successfully authenticated towards a trusted Identity Provider but no group mapping can be performed, the SAML authentication driver will automatically add that user to the OpenNebula group defined in `:mapping_default`.{{< /alert >}}

{{< alert title="Note" color="success" >}}
Note that user groups are defined on login. This means that, if a user is already logged in and the group map is updated, the user groups will be updated the next time the user is authenticated. Also note that a user may be using a login token that needs to expire for this change to take effect. The maximum lifetime of a token can be set in `oned.conf` for each driver. If you want groups to be fully managed from OpenNebula (not from the Identity Provider), update `DRIVER_MANAGED_GROUPS` in the `saml` `AUTH_MAD_CONF` configuration attribute.{{< /alert >}}

### Group Admin. Mapping

Each group in OpenNebula can have its [admins]({{% relref "../multitenancy/manage_groups#manage-groups-permissions" %}}), special group members that have administrative privileges for the group. Also, this attribute can be controlled through the Identity Provider. For this purpose there is an option: `:group_admin_name`. This needs to be set to the name of a group in the Identity Provider. If a user is a member of that group, this user will be a group admin of ALL mapped groups in ONE.

## Assertion Consumer Service (ACS)

The Assertion Consumer Service (ACS) is a crucial component of the SAML authentication flow. It is the endpoint where clients POST the SAML assertion obtained from the Identity Provider. This happens after a successful authentication towards the Identity Provider.

In OpenNebula, this functionality is handled by the FireEdge component, which exposes a dedicated ACS endpoint: `https://<your-fireedge-domain>/fireedge/api/auth/acs`.


## Sample Identity Provider Configurations

This section includes configuration guides for some common SAML Identity Providers.

### Keycloak

In order to configure Keycloak as an Identity Provider for OpenNebula, your will need to create a SAML client. Navigate to your Keycloak realm (or create a new one for OpenNebula) and go to the Clients section.

Create a new client by clicking on `Create client`. Set the following general settings:
- **Client type** - `SAML`
- **Client ID** - Must match the :sp_entity_id attribute defined in `/etc/one/auth/saml_auth.conf`.


Click `Next` and set the following Login settings:
- **IDP-Initiated SSO URL name** - Same value as `Client ID`.
- **Master SAML Processing URL** - Refers to the ACS URL. Must match the value of the :acs_url field in the OpenNebula SAML configuration file. E.g.: `https://your-fireedge-domain.com/fireedge/api/auth/acs`

Save the client configuration. Once the client has been successfully created, you can configure Keycloak to report group membership to OpenNebula:
1. Navigate to the new Client
2. Navigate to the **Client scopes** tab and select the scope with the `-dedicated` termination
3. On the **Mappers** tab, click on **Add mapper**. Select **By configuration**.  Choose **Group list** from the list of possible mappers.
4. Use the following settings:
    - **Name**: `group_mapper`
    - **Group attribute name**: Must match the :group_field attribute defined in `/etc/one/auth/saml_auth.conf` for the Identity Provider. Typical values are `member` and `memberOf`
    - **SAML Attribute NameFormat**: `Basic`
    - **Single Group Attribute**: `On`
    - **Full group path**: `On`
    - For additional settings not specified here, use the default value.
5. Click **Save**.

Once group membership reporting has been configured in Keycloak, you can proceed with the OpenNebula SAML auth driver configuration (`/etc/one/auth/saml_auth.conf`):
- **:sp_entity_id** - must match your Keycloak **Client ID**
- **:acs_url** - must match the URL configured in Keycloak as **Master SAML Processing URL**
- **:issuer** - defaults to `http(s)://<keycloak_ip>:<keycloak_port>/realms/<keycloak_realm_name>`. Can be obtained from the Keycloak web interface via the SAML Identity Provider metadata XML: Realm Settings => Endpoints => SAML 2.0 Identity Provider Metadata => **entityID** parameter.
- **:idp_cert** - can be obtained from the Keycloak web interface: Realm Settings => Keys => Look for the RSA key used for signing (SIG) => Certificate. May also be obtained from the SAML Identity Provider metadata XML: Realm Settings => Endpoints => SAML 2.0 Identity Provider Metadata => **X509Certificate**.
- **:group_field** - Must match the **Group attribute name** defined in the Keycloak group mapper.
- **:mapping_mode** - `keycloak`. This mode includes special logic to handle Keycloak group nesting.

All other IdP-specific configuration settings for the driver should be set up the same way as for any other Identity Provider.

{{< alert title="Note" color="success" >}}
Be aware that, with this configuration, group nesting is enabled. This means that a user member of the Keycloak group /group1/subgroup1 is considered both a member of group1 and a member of subgroup1. In case of having mappings configured for both the group and the subgroup, the user will be considered a member of both OpenNebula groups. To disable this behavior you can set the **:mapping_mode** configuration attribute to `strict` and turn off **Full group path** in your Keycloak Group Mapper.{{< /alert >}}


### Okta

In order to configure Okta as an Identity Provider for OpenNebula, your will need to create an App Integration:
1. Access your Okta admin console and navigate to Applications => Applications.
2. Click on **Create App Integration** and select `SAML 2.0`.
3. Write a name for your application and click **Next**.
4. Use the following SAML settings:
    - **Single sign-on URL**: Refers to the ACS URL. Must match the value of the :acs_url field in the OpenNebula SAML configuration file. E.g.: `https://your-fireedge-domain.com/fireedge/api/auth/acs`
    - **Audience URI**: Refers to the **:sp_entity_id** defined in `/etc/one/auth/saml_auth.conf`.
    - **Group Attribute Statements**: Add a group attribute statement with:
        - **Name**: Must match the :group_field attribute defined in `/etc/one/auth/saml_auth.conf` for the Identity Provider. Typical values are `member` and `memberOf`
        - **Name format**: `Unspecified`
        - **Filter**: This option is used to filter the groups that are allowed to be reported to the Service Provider (OpenNebula). If all groups can be reported, select **Matches regex** and use the regular expression `.*`
    - For additional settings not specified here, use the default value.
5. Click **Save**.

You can proceed with the OpenNebula SAML auth driver configuration (`/etc/one/auth/saml_auth.conf`):
- **:sp_entity_id** - must match your Okta **Audience URI**.
- **:acs_url** - must match the URL configured in Okta as **Single sign-on URL**
- **:issuer** - can be obtained from the Okta web interface: Applications => Applications => Click on the newly created application => Sign On => Metadata details => More details => **Issuer**
- **:idp_cert** - can be obtained from the Okta web interface: Applications => Applications => Click on the newly created application => Sign On => Metadata details => More details => **Signing Certificate**
- **:group_field** - Must match the **Name** defined in the **Group Attribute Statements** section when creating the Okta application.
- **:mapping_mode** - `strict`. Group nesting is not supported for Okta.

All other IdP-specific configuration settings for the driver should be set up the same way as for any other Identity Provider.