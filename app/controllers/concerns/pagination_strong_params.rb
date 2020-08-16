module PaginationStrongParams extend ActiveSupport::Concern
included do
  before_action :set_pagination_params

  def set_pagination_params
    @per_page = params[:per_page] || APP_CONFIG['default_per_page']
    @page_no = params[:page_no]|| 1
    RequestStore.store[:per_page] = @per_page
    RequestStore.store[:page_no] = @page_no
  end

  def per_page
    @per_page
  end

  def page_no
    @page_no
  end
end
end