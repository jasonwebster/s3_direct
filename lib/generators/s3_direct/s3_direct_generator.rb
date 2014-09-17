require "rails/generators/active_record"

class S3DirectGenerator < ActiveRecord::Generators::Base
  desc "Create migration to add s3 file to given model."

  argument :file_names, required: true, type: :array, desc: "The names of files to add"

  def self.source_root
    @source_root ||= File.expand_path('../templates', __FILE__)
  end

  def generate_migration
    migration_template "s3_direct_migration.rb.erb", "db/migrate/#{migration_name}.rb"
  end

  def migration_name
    "add_file_#{file_names.join("_")}_to_#{name.tableize}"
  end
end

