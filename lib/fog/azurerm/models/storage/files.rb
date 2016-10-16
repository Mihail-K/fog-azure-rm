require 'fog/core/collection'
require 'fog/azurerm/models/storage/file'

module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of listing blobs.
      class Files < Fog::Collection
        model Fog::Storage::AzureRM::File
        attribute :directory

        def all(options = { metadata: true })
          files = service.list_blobs(directory, options).map do |blob|
            File.parse(blob).merge!('directory' => directory)
          end
          load files
        end

        def get(directory, name = nil)
          if name.nil?
            requires :directory
            name = directory
            directory = self.directory
          end
          File.new(service: service, directory: directory, key: name)
        end

        def new(attributes = {})
          requires :directory
          super({ directory: directory }.merge!(attributes))
        end
      end
    end
  end
end
