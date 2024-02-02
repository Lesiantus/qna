class SearchController < ApplicationController
  skip_authorization_check

  def search
    @data = service.result(search_params)
  end

  private

  def service
    @service ||= IndexedSearch.new
  end

  def search_params
    params.permit(%i[query question answer comment user page commit])
  end
end
