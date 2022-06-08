# API Urls controller to manage shortened urls (CRUD)
class UrlsController < ApplicationController
  def show
    slug = params[:slug]
    if slug.blank?
      render json: { message: 'Slug is empty' }, status: 400
      return
    end

    url = Url.where(slug: slug).first
    if url.present?
      render json: url.to_api, status: 200
      return
    end

    render json: { message: 'Slug not found' }, status: 400
  end

  def create
    params[:long_url] ||= ''
    long_url = params[:long_url].strip
    url = Url.find_or_create!(long_url: long_url)
    if url.blank?
      render json: { message: 'Not a valid long_url' }, status: 400
      return
    end

    render json: url.to_api, status: 200
  end
end
