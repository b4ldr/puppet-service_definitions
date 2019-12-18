# @summary class to add a hash of service definitions to /etc/services
# @param services a hash of service_description resources definitions
class service_definitions (
    Hash[String,Service_definitions::Service] $services
) {
    $services.each |String $service, Service_definitions::Service $config| {
        service_definition { $service:
            * => $config,
        }
    }
}

