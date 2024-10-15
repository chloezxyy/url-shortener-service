class ReportsController < ApplicationController
  def index
    begin
      @reports = Visit.joins(:url)
      .select("urls.short_url, visits.geolocation, visits.created_at AS timestamp, COUNT(visits.id) OVER (PARTITION BY urls.short_url) AS click_count, ROW_NUMBER() OVER (PARTITION BY urls.short_url ORDER BY visits.created_at) AS row_num")
      .order("urls.short_url, visits.created_at DESC")

      render :index, status: :ok
    rescue => e
      render json: { errors: "Unable to display report", message: e }, status: :not_found
    end
  end
end
