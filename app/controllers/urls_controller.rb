require "securerandom"
require "base62"
require "nokogiri"
require "geocoder"
require "open-uri"

class UrlsController < ApplicationController
  def new
    @url = Url.new
  end

  def create
    begin
      # Step 1: retrieve the original_url from the form - original_url is valid and not empty
      original_url = params[:url][:original_url]

      # Step 2: fetch the title of the page
      title = fetch_title(original_url)

      # Step 3: Generate a unique short_url with retry limit
      short_url = nil
      loop do
        short_url = generate_unique_short_url
        break unless Url.find_by(short_url: short_url)
      end

      # Step 4: create a new Url object with the original_url, short_url, and title
      @url = Url.new(original_url: original_url, short_url: short_url, title: title)

      # display the error message if the url is not valid
      unless @url.valid?
        render :new, status: :unprocessable_entity
        return
      end
      # Step 5: ensure that short_url is valid and save to the database
      begin
        if @url.save!
          render :show,  status: :created
        else
          render json: { errors: @url.errors.full_messages }, status: :unprocessable_entity
          nil
        end
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: @url.errors.full_messages }, status: :unprocessable_entity
        nil
      end

      # To handle any exceptions
    rescue StandardError => e
      render json: { errors: e.message }, status: :internal_server_error
      nil
    end
  end

  def index
    redirect_to new_url_path
  end

  # Redirect to the original URL (whether if user clicks or pastes the short URL)
  def redirect
    @url = Url.find_by(short_url: params[:short_url])

    if @url
      redirect_to(@url.original_url, allow_other_host: true)
      performed?

      user_ip = request.remote_ip
      geolocation = Geocoder.search(user_ip)
      country_name = geolocation.first&.country || "Unknown"

      # save details of the visit into visits table
      Visit.create(url: @url, ip_address: user_ip, geolocation: country_name,)
    else
      render file: "#{Rails.root}/public/404.html", status: 404
    end
  end

  private

  def fetch_title(website_link)
    html = URI.open(website_link)
    doc = Nokogiri::HTML(html)
    title = doc.at_css("title").text
    title
  rescue => e
    "Unknown title"
  end

  def generate_unique_short_url
    max_retries = 5
    attempts = 0

    begin
      short_url = Base62.encode(SecureRandom.random_number(1_000_000))
      while Url.find_by(short_url: short_url)
        break if attempts >= max_retries

        short_url = Base62.encode(SecureRandom.random_number(1_000_000))
        attempts += 1
      end

      return short_url if attempts < max_retries
    rescue StandardError => e
      Rails.logger.error "Failed to generate unique short URL: #{e.message}"
    end
    nil
  end
end
