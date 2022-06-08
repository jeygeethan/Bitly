# Root controller for redirecting to long_urls
class RootController < ApplicationController
  def index
    slug = params[:slug]
    url = Url.where(slug: slug).first
    if url.blank?
      render json: { message: 'Slug not found' }, status: 404
      return
    end

    redirect_to url.long_url, status: 301, allow_other_host: true
  end
end
