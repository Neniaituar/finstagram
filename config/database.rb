configure do
  # Log queries to STDOUT in development
    if Sinatra::Application.development?
        ActiveRecord::Base.logger = Logger.new(STDOUT)
    end

    if Sinatra::Application.development?
        set :database, {
            adapter: "sqlite3",
            database: "db/db.sqlite3"
        }
    else
        db_url = 'postgres://[postgres://ckhbffuqdblkxv:8c7ae0aa0e01ae79b072d4139b4f7f958e624c2163390bdd1b8a377aa712d5c3@ec2-23-20-129-146.compute-1.amazonaws.com:5432/db4dm6cn6a2g8b]'
        db = URI.parse(ENV['DATABASE_URL'] || db_url)
        set :database, {
            adapter: "postgresql",
            host: db.host,
            username: db.user,
            password: db.password,
            database: db.path[1..-1],
            encoding: 'utf8'
        }
    end

  # Load all models from app/models, using autoload instead of require
  # See http://www.rubyinside.com/ruby-techniques-revealed-autoload-1652.html
    Dir[APP_ROOT.join('app', 'models', '*.rb')].each do |model_file|
        filename = File.basename(model_file).gsub('.rb', '')
        autoload ActiveSupport::Inflector.camelize(filename), model_file
    end

end