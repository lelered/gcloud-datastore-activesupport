# encoding: UTF-8


module ActiveSupport
  module Cache
    class GcloudDatastore < Store

      # attr_reader :project_id

      def initialize(*options)
        super(options)
      end


      private

      # Reads an entry from the cache implementation. Subclasses must implement
      # this method.
      def read_entry(key, options)
      end

      # Writes an entry to the cache implementation. Subclasses must implement
      # this method.
      def write_entry(key, entry, options)
      end

      # Deletes an entry from the cache implementation. Subclasses must
      # implement this method.
      def delete_entry(key, options)
      end

    end
  end
end
