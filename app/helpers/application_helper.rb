module ApplicationHelper
  def create_pager_with_entries(collection, params, remote)
    params = {} if params.blank?
    remote = false if remote.blank?
    render partial: 'common/pager_with_entries', locals: {collection: collection, params: params, remote: remote}
  end
end
