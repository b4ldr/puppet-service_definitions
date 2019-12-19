Puppet::Type.type(:service_definition).provide(:nix) do
  mk_resource_methods

  def self.parse_services
    services = Hash.new do |h, k|
      h[k] = {
        protocols: [],
        description: nil,
        aliases: [],
      }
    end
    pattern = %r{(\w+)\s+(\d+)/(udp|tcp|ddp)\s+([^#]+)?(?:#\s+(.*))?}
    File.open('/etc/services') do |f|
      f.each_line do |line|
        m = line.match(pattern)
        next unless m
        services[m[1]][:port] = m[2]
        services[m[1]][:protocols] << m[3]
        services[m[1]][:aliases] = m[4].split if m[4]
        services[m[1]][:description] = m[5] if m[5]
      end
    end
    services
  end

  def self.instances
    parse_services.map do |key, properties|
      service = {}
      service[:provider] = :nix
      service[:ensure] = :present
      service[:name] = key
      service[:port] = properties[:port]
      service[:protocols] = properties[:protocols]
      service[:aliases] = properties[:aliases]
      service[:description] = properties[:description]
      new(service)
    end
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name] # rubocop:disable Lint/AssignmentInCondition
        resource.provider = prov
      end
    end
  end

  def flush
    content = ''
    IO.readlines('/etc/services').each do |line|
      # if we manage the service delete it then write it at the bottom
      content += line unless line.match?(%r{^#{resource[:name]}\b})
    end
    if resource[:ensure] == :present
      resource[:protocols].each do |protocol|
        content += "#{resource[:name]}\t#{resource[:port]}/#{protocol}"
        content += "\t#{resource[:aliases].join(' ')}" if resource[:aliases]
        content += "\t# #{resource[:description]}" if resource[:description]
        content += "\n"
      end
    end
    File.open('/etc/services', 'w') do |f|
      f.puts content
    end
  end

  def initialize(value = {})
    super(value)
    @property_flush = {}
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    @property_flush[:ensure] = :present
  end

  def destroy
    @property_flush[:ensure] = :absent
  end
end
