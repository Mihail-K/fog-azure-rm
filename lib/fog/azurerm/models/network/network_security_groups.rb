require 'fog/core/collection'
require 'fog/azurerm/models/network/network_security_group'

module Fog
  module Network
    class AzureRM
      # collection class for Network Security Group
      class NetworkSecurityGroups < Fog::Collection
        model Fog::Network::AzureRM::NetworkSecurityGroup
        attribute :resource_group

        def all
          requires :resource_group
          network_security_groups = []
          service.list_network_security_groups(resource_group).each do |nsg|
            network_security_groups << Fog::Network::AzureRM::NetworkSecurityGroup.parse(nsg)
          end
          load(network_security_groups)
        end

        def get(resource_group, name)
          nsg = service.get_network_security_group(resource_group, name)
          network_security_group = Fog::Network::AzureRM::NetworkSecurityGroup.new(service: service)
          network_security_group.merge_attributes(Fog::Network::AzureRM::NetworkSecurityGroup.parse(nsg))
        end
      end
    end
  end
end
