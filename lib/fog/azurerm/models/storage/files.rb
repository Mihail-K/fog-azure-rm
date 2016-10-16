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
          directory = directory.key if directory.is_a?(Fog::Storage::AzureRM::Directory)
          File.new(service: service, directory: directory, key: name)
        end

        def new(attributes = {})
          requires :directory unless attributes.key?(:directory)
          super({ directory: directory.key }.merge!(attributes))
        end
      end
    end
  end
end
