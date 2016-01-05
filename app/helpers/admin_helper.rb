module AdminHelper

  def sidebar_activate(path)
    if path.include?("#{params[:controller]}") && path.include?("#{params[:action]}")
      ' class="active"'
    else
      ''
    end
  end

  def sidebar_list_items
    items = [
        {:text => "#{t('admin.sidebar.user')}", :path => admin_users_path},
        {:text => "#{t('admin.sidebar.bus_stop')}", :path => admin_bus_stops_path},
        {:text => "#{t('admin.sidebar.photos')}", :path => admin_photos_index_path},
        {:text => "#{t('admin.sidebar.reports')}", :path => admin_photos_reporting_path},
    ]

    html = ''
    items.each do |item|
      text = item[:text]
      path = item[:path]
      html = html + %Q(<li#{sidebar_activate(path)}><a href="#{path}">#{text}</a></li>)
    end
    raw(html)
  end

  def is_admin_layout?
    params[:controller].include?("admin")
  end
end