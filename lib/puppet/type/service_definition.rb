# frozen_string_literal: true

Puppet::Type.newtype(:service_definition) do
  desc 'Puppet type to manage entries in /etc/services'

  ensurable

  newparam(:name, namevar: true) do
    desc 'Name of the service'
    munge do |value|
      value.downcase
    end
  end

  newproperty(:port) do
    desc 'Port the service listens on'
    newvalues(%r{^\d+$})
  end

  newproperty(:description) do
    desc 'Description of the service'
  end

  newproperty(:aliases, array_matching: :all) do
    desc 'Service aliases'
    newvalues(%r{^\w+$})
    def insync?(is)
      is.sort == should.sort
    end
  end

  newproperty(:protocols, array_matching: :all) do
    desc 'list of tcp, udp or ddp supported by this service'
    newvalues(%r{udp|tcp|ddp})
    munge do |value|
      value.downcase
    end
    def insync?(is)
      is.sort == should.sort
    end
  end
end
