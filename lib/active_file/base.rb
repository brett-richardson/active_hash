module ActiveFile

  class Base < ActiveHash::Base

    if respond_to?(:class_attribute)
      class_attribute :filename, :root_path, :data_loaded
    else
      class_inheritable_accessor :filename, :root_path, :data_loaded
    end

    class << self

      def all(options={})
        reload unless data_loaded
        super
      end

      def where(options)
        reload unless data_loaded
        super
      end

      def delete_all
        self.data_loaded = true
        super
      end

      def reload(force = false)
        return if !self.dirty && !force && self.data_loaded
        self.data_loaded = true
        self.data = load_file
        mark_clean
      end

      def set_filename(name)
        self.filename = name
      end

      def set_root_path(path)
        self.root_path = path
      end

      def load_file
        raise "Override Me"
      end

      def full_path
        actual_root_path = root_path  || Dir.pwd
        actual_filename  = filename   || name.tableize
        File.join(actual_root_path, "#{actual_filename}.#{extension}")
      end

      def extension
        raise "Override Me"
      end

      protected :extension

    end
  end

end
