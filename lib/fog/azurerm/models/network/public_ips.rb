require 'fog/core/collection'
require 'fog/azurerm/models/network/public_ip'

module Fog
  module Network
    class AzureRM
      # PublicIPs collection class for Network Service
      class PublicIps < Fog::Collection
        model Fog::Network::AzureRM::PublicIp
        attribute :resource_group

        def all
          requires :resource_group
          public_ips = []
          service.list_public_ips(resource_group).each do |pip|
            public_ips << Fog::Network::AzureRM::PublicIp.parse(pip)
          end
          load(public_ips)
        end

        def get(resource_group_name, public_ip_name)
          public_ip = service.get_public_ip(resource_group_name, public_ip_name)
          public_ip_object = Fog::Network::AzureRM::PublicIp.new(service: service)
          public_ip_object.merge_attributes(Fog::Network::AzureRM::PublicIp.parse(public_ip))
        end

        def check_if_exists(resource_group, name)
          Fog::Logger.debug "Checkng if PublicIP #{name} exists."
          if service.check_for_public_ip(resource_group, name)
            Fog::Logger.debug "PublicIP #{name} exists."
            true
          else
            Fog::Logger.debug "PublicIP #{name} doesn't exists."
            false
          end
        end
      end
    end
  end
end
