rails_resque_redis_file = File.open(File.join(Rails.root, *%w[config rails_resque_redis.yml]))

REDIS_HOSTS = YAML::load(File.open(rails_resque_redis_file)) if File.exists?(rails_resque_redis_file)