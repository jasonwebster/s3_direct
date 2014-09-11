module S3Direct
  class Object

    def initialize(model, column_name, options)
      @model = model
      @column_name = column_name
      @options = options
    end

    def key
      @model.send(@column_name)
    end

    def object
      bucket.objects[key] if key
    end

    def url(expires = 30.minutes)
      object.url_for(:read, expires: expires) if key
    end

    def bucket
      @bucket ||= S3Direct.s3_bucket(@options[:bucket])
    end

  end
end
