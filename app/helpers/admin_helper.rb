module AdminHelper

  def sidebar_activate(path)
    if path.include?("#{params[:controller]}/")
      ' class="active"'
    else
      ''
    end
  end

  def sidebar_list_items
    current_url = request.headers['PATH_INFO']
    items = [
        {:text => "#{t('admin.sidebar.user')}", :path => ""},
        {:text => "#{t('admin.sidebar.bus_stop')}", :path => ""},
        {:text => "#{t('admin.sidebar.photos')}", :path => ""},
    ]

    html = ''
    items.each do |item|
      text = item[:text]
      path = item[:path]
      html = html + %Q(<li#{sidebar_activate(path)}><a href="#{path}">#{text}</a></li>)
    end
    raw(html)
  end
end