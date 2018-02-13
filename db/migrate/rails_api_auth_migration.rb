private def migration_parent_class
  if Rails.version >= '5.0.0'
    ActiveRecord::Migration["#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}"]
  else
    ActiveRecord::Migration
  end
end

class RailsAPIAuthMigration < migration_parent_class
end
