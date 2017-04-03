Redmine::OmniAuthSAML::Base.configure do |config|
  config.saml = {
    :assertion_consumer_service_url => "http://localhost:10083/auth/saml/callback", # The redmine application hostname
    :issuer                         => "http://localhost:10083",                 # The issuer name
    :idp_sso_target_url             => "https://ssoweb.int.i-administracion.junta-andalucia.es/opensso/SSORedirect/metaAlias/correo/idp", # SSO login endpoint
    :idp_cert_fingerprint           => "DE:F1:8D:BE:D5:47:CD:F3:D5:2B:62:7F:41:63:7C:44:30:45:FE:33", # SSO ssl certificate fingerprint
    :name_identifier_format         => "urn:oasis:names:tc:SAML:2.0:nameid-format:persistent",
    :signout_url                    => "http://localhost:10083/logout",
    :idp_slo_target_url             => "https://ssoweb.int.i-administracion.junta-andalucia.es/opensso/logout",
    :name_identifier_value          => "uid", # Which redmine field is used as name_identifier_value for SAML logout
    :attribute_mapping              => {
    # How will we map attributes from SSO to redmine attributes
      :login      => 'extra.raw_info.uid',
      :firstname  => 'extra.raw_info.givenName',
      :lastname   => 'extra.raw_info.sn',
      :mail       => 'extra.raw_info.mail'
    }
  }

  config.on_login do |omniauth_hash, user|
    # Implement any hook you want here
  end
end
