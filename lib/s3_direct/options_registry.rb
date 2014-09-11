module S3Direct
  class OptionsRegistry

    def initialize
      @options = {}
    end

    def set(klass, name, options)
      class_options(klass)[name] = options
    end

    def get(klass, name)
      class_options(klass)[name]
    end

    private

    def class_options(klass)
      @options[klass] ||= {}
    end

  end
end
