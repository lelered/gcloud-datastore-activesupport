# encoding: UTF-8
require "google/cloud/datastore"
require "zlib"


module ActiveSupport
  module Cache
    class GcloudDatastore < Store

      # attr_reader :project_id

      def initialize(*options)
        super(options)
        @options = options.extract_options!
        @project_id = @options[:project_id] || Rails.application.config.database_configuration[Rails.env]["dataset_id"]
        @credential_file_json = @options[:credential_file_json]
        @serialize_content_zip_enabled = (@options[:content_zip].blank? || @options[:content_zip]) ? true : false
        @serialize_content_base64_enabled = (@options[:content_base64].blank? || @options[:content_base64]) ? true : false
        @datastore_kind_name = @options[:kind_name] || "cache_#{ Rails.env }"
      end


      private

      # Reads an entry from the cache implementation. Subclasses must implement
      # this method.
      def read_entry(key, options)
        query    = Google::Cloud::Datastore::Key.new @datastore_kind_name, key
        entities = dataset.lookup query
        return nil unless entities.any?
        entity   = entities.first
        entry = deserialize_entry( entity[:_value], entity[:_format] )
        return entry
      end

      # Writes an entry to the cache implementation. Subclasses must implement
      # this method.
      def write_entry(key, entry, options)
        value, format = serialize_entry( entry )
        obj = dataset.entity @datastore_kind_name, key do |t|
          t["_expires"] = entry.expires_at
          t["_format"] = format
          t["_value"] = value
          t["_json"] = entry.to_json unless Rails.env.production? || entry.to_json.size >= 1500
        end
        dataset.save obj
        return true
      rescue Exception => e
        return false
      end

      # Deletes an entry from the cache implementation. Subclasses must
      # implement this method.
      def delete_entry(key, options)
        dataset.delete Google::Cloud::Datastore::Key.new @datastore_kind_name, key
      end

      def dataset
        @dataset ||= Google::Cloud::Datastore.new(
            project_id: @project_id,
            credentials: @credential_file_json.blank? ? nil : Google::Cloud::Datastore::Credentials.new( @credential_file_json )
        )
      end

      def serialize_entry( entry )
        format = []
        entry = Marshal.dump( entry )
        if @serialize_content_zip_enabled
          entry = Zlib::Deflate.deflate( entry )
          format << "zip"
        end
        if @serialize_content_base64_enabled
          entry = Base64.encode64( entry ) if @serialize_content_base64_enabled
          format << "base64"
        end
        return entry, format.join("_")
      end

      def deserialize_entry( entry, format = nil )
        format ||= "zip_base64"
        entry = Base64.decode64( entry ) if format.include? "base64"
        entry = Zlib::Inflate.inflate( entry ) if format.include? "zip"
        Marshal.load( entry )
      end

    end
  end
end
