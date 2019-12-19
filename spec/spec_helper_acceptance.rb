# frozen_string_literal: true

require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'
require 'beaker-rspec'

modules = [
  'puppetlabs-stdlib',
]
def install_modules(host, modules)
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  install_dev_puppet_module_on(host, source: module_root)
  modules.each do |m|
    on(host, puppet('module', 'install', m))
  end
end
hosts.each do |host|
  step "install puppet on #{host}"
  host.install_package('puppet')
  step "install puppet modules on #{host}"
  install_modules(host, modules)
  step 'Enable IPv6'
  on(host, 'sysctl net.ipv6.conf.all.disable_ipv6=0')
end
RSpec.configure do |c|
  c.formatter = :documentation
  # c.before :suite do
  #   hosts.each do |host|
  #   end
  # end
end
