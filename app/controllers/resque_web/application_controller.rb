module ResqueWeb
  class ApplicationController < ActionController::Base
    protect_from_forgery
    before_filter :set_redis, :set_subtabs, :authorize 

    helper :all

    def self.subtabs(*tab_names)
      return defined?(@subtabs) ? @subtabs : [] if tab_names.empty?
      @subtabs = tab_names
    end

    def set_subtabs(subtabs = self.class.subtabs)
      @subtabs = subtabs
    end

    private

    def set_redis
      warn 'request----'
      warn request.inspect
      warn request.env.inspect
      warn REDIS_HOSTS
      warn 'redis hosts'
      Resque.redis = ENV['RAILS_RESQUE_REDIS'] || REDIS_HOSTS['hosts'][request.env['REQUEST_PATH'].split('/')[1]]
    end

    def authorize
      if ENV["RESQUE_WEB_HTTP_BASIC_AUTH_USER"] && ENV["RESQUE_WEB_HTTP_BASIC_AUTH_PASSWORD"]
        authenticate_or_request_with_http_basic {|u, p| u == ENV["RESQUE_WEB_HTTP_BASIC_AUTH_USER"] && p == ENV["RESQUE_WEB_HTTP_BASIC_AUTH_PASSWORD"] }
      end
    end
  end
end
