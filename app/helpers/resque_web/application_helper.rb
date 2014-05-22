module ResqueWeb
  module ApplicationHelper

    PER_PAGE = 20

    def tabs
       t =  {'overview' => url_helper(ResqueWeb::Engine.app.url_helpers.overview_path),
             'working'  => url_helper(ResqueWeb::Engine.app.url_helpers.working_index_path),
             'failures' => url_helper(ResqueWeb::Engine.app.url_helpers.failures_path),
             'queues'   => url_helper(ResqueWeb::Engine.app.url_helpers.queues_path),
             'workers'  => url_helper(ResqueWeb::Engine.app.url_helpers.workers_path),
             'stats'    => url_helper(ResqueWeb::Engine.app.url_helpers.stats_path)
      }
      ResqueWeb::Plugins.plugins.each do |p|
        p.tabs.each { |tab| t.merge!(tab) }
      end
      t
    end

    def url_helper(path_link)
      path_link.gsub(/(#{REDIS_HOSTS['hosts'].keys.join('|')})/,  request.env['REQUEST_URI'].split('/')[1])
    end

    def hosts
      REDIS_HOSTS['hosts'].keys
    end

    def host_path(host)
      ResqueWeb::Engine.app.url_helpers.root_path.gsub(/(#{REDIS_HOSTS['hosts'].keys.join('|')})/,  host)
    end

    def tab(name,path)
      content_tag :li, link_to(name.capitalize, path), :class => current_tab?(name) ? "active" : nil
    end

    def current_tab
      params[:controller].gsub(/resque_web\//, "#{root_path}")
    end

    def current_tab?(name)
      params[:controller] == name.to_s
    end

    attr_reader :subtabs

    def subtab(name)
      content_tag :li, link_to(name, "#{current_tab}/#{name}"), :class => current_subtab?(name) ? "current" : nil
    end

    def current_subtab?(name)
      params[:id] == name.to_s
    end

    def pagination(options = {})
      start    = options[:start] || 1
      per_page = options[:per_page] || PER_PAGE
      total    = options[:total] || 0
      return if total < per_page

      markup = ""
      if start - per_page >= 0
        markup << link_to(raw("&laquo; less"), params.merge(:start => start - per_page), :class => 'btn less')
      end

      if start + per_page <= total
        markup << link_to(raw("more &raquo;"), params.merge(:start => start + per_page), :class => 'btn more')
      end

      content_tag :p, raw(markup), :class => 'pagination'
    end

    def poll(polling=false)
      if polling
        text = "Last Updated: #{Time.now.strftime("%H:%M:%S")}".html_safe
      else
        text = "<a href='#{h(request.path)}' rel='poll'>Live Poll</a>".html_safe
      end
      content_tag :p, text, :class => 'poll'
    end
  end
end
