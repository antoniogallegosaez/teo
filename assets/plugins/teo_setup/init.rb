Redmine::Plugin.register :teo_setup do
  name 'Teo Setup plugin'
  author 'Junta de Andalucía'
  description 'Pre-configures redmine with TEOs standard configuration'
  version '0.0.1'
  url 'http://www.juntadeandalucia.es/repositorio/'
  author_url 'http://www.juntadeandalucia.es'
  settings :default => {'empty' => true}, :partial => 'settings/teo_setup_settings'
end
