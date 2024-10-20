class ReportsController < ApplicationController
  # To retrieve two tables, one with the most visited URLs and another with the number of clicks per URL
  def index
    @reports = aggregate_by_urls
    @click_counts = aggregate_by_clicks
    render :index, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def analytics_url
    @reports = aggregate_by_urls
    render :index, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def click_count
    @click_counts = aggregate_by_clicks
    render :index, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def aggregate_by_clicks
    Visit.joins(:url)
      .select("urls.short_url, MAX(visits.created_at) AS last_visit, COUNT(visits.id) AS total_clicks")
      .group("urls.short_url")
      .order("last_visit DESC")
  end

  def aggregate_by_urls
    Visit.joins(:url)
    .select("urls.short_url, visits.geolocation, visits.created_at AS timestamp")
    .order("timestamp DESC")
  end
end
