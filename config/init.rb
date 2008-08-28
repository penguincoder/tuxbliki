Gem.clear_paths
Gem.path.unshift(Merb.root / "gems")
$LOAD_PATH.unshift(Merb.root / "lib")

Merb::Config.use do |c|
  c[:session_secret_key]  = '9e6d92dd24c39be48946fc947255476fa4d7f7e9'
  c[:session_store] = :activerecord
end

use_orm :activerecord
use_test :rspec

dependencies 'merb_helpers', 'merb_has_flash', 'merb-mailer'
require 'merb_exceptions'
require 'redcloth'
require 'RMagick'
require 'memcache'
require 'memcache_util'
require 'recaptcha'

Merb::BootLoader.after_app_loads do
  config_path = File.join(Merb.root, 'config', 'memcache.yml')
  if File.file?(config_path) and File.readable?(config_path)
    memcache_connection_str = YAML.load(File.read(config_path))
  else
    memcache_connection_str = 'localhost:11211'
  end
  CACHE = MemCache.new memcache_connection_str
  
  Merb::Mailer.config = { :sendmail_path => '/usr/sbin/sendmail' }
  Merb::Mailer.delivery_method = :sendmail
  
  recaptcha_path = File.join(Merb.root, 'config', 'recaptcha.yml')
  if File.file?(recaptcha_path) and File.readable?(recaptcha_path)
    rc = YAML::load_file(recaptcha_path)
    ENV['RECAPTCHA_PUBLIC_KEY'] = rc[:public]
    ENV['RECAPTCHA_PRIVATE_KEY'] = rc[:private]
  else
    raise "ReCaptcha configuration file not found!"
  end
end
