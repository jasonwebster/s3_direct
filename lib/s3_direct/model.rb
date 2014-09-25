module S3Direct
  module Model
    extend ActiveSupport::Concern

    FORWARDABLE_METHODS = [:url]

    DEFAULT_OPTIONS = {
      bucket: S3Direct.default_bucket,
      policy: { # @see http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/S3/PresignedPost.html
        secure: true,
        expires: 1800, # seconds
        success_action_status: 201
      }
    }.freeze

    module ClassMethods
      # @param name
      def has_s3_file(name = :file, options = {})
        S3Direct.options.set(self, name, options.merge(name: name).reverse_merge(DEFAULT_OPTIONS))

        instance_variable = "@s3_direct_#{name}"

        define_method name do
          options = S3Direct.options.get(self.class, name)

          instance_variable_get(instance_variable) || instance_variable_set(
            instance_variable, S3Direct::Object.new(self, "#{name}_key", options)
          )
        end

        delegate *FORWARDABLE_METHODS, to: name, prefix: name
      end
    end

  end
end
