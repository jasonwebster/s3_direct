require "s3_direct/version"
require "aws-sdk"
require "active_support/core_ext/module/attribute_accessors"

module S3Direct
  autoload :Controller,      's3_direct/controller'
  autoload :Model,           's3_direct/model'
  autoload :Object,          's3_direct/object'
  autoload :OptionsRegistry, 's3_direct/options_registry'

  # Configuration options.
  #
  # These are best suited set in an initializer in your application.

  @@default_bucket = ENV["S3_DIRECT_BUCKET"]
  mattr_accessor :default_bucket

  @@aws_credentials = {
    access_key_id: ENV["AWS_ACCESS_KEY_ID"],
    secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
  }
  mattr_accessor :aws_credentials

  class << self

    def configure(&block)
      instance_exec(self, &block) if block_given?
    end

    def options
      @options ||= OptionsRegistry.new
    end

    # TODO allow this stuff to be set via an initializer
    def s3_client
      @s3_client ||= AWS::S3.new(aws_credentials)
    end

    # TODO cache bucket objects
    def s3_bucket(name)
      s3_client.buckets[name]
    end

    def upload_policy_for(klass, name, policy = {})
      options = self.options.get(klass, name)
      AWS::S3::PresignedPost.new(self.s3_bucket(options[:bucket]), options[:policy].merge(policy))
        .where(:acl).is(:private) # TODO make configurable
    end

  end

end
