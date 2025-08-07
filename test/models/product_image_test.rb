require "test_helper"
require "net/http"
require "uri"

class ProductImageTest < ActiveSupport::TestCase
  test "all product photos should be accessible" do
    broken_images = []

    Product.all.each do |product|
      next if product.photo.blank?

      begin
        uri = URI.parse(product.photo)

        # Skip non-HTTP URLs
        next unless uri.scheme&.match?(/^https?$/)

        # Make HEAD request to check if image exists
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == "https")
        http.open_timeout = 10
        http.read_timeout = 10

        request = Net::HTTP::Head.new(uri.request_uri)
        request["User-Agent"] = "Rails Test Suite"

        response = http.request(request)

        # Consider 2xx and 3xx status codes as success
        unless response.code.start_with?("2", "3")
          broken_images << {
            product: product.name,
            photo_url: product.photo,
            status_code: response.code,
            error: "HTTP #{response.code} #{response.message}"
          }
        end

      rescue => e
        broken_images << {
          product: product.name,
          photo_url: product.photo,
          error: e.message
        }
      end
    end

    if broken_images.any?
      error_message = "Found #{broken_images.length} broken image(s):\n"
      broken_images.each do |broken_image|
        error_message += "- #{broken_image[:product]}: #{broken_image[:photo_url]} (#{broken_image[:error]})\n"
      end
      flunk error_message
    else
      assert true, "All product photos are accessible"
    end
  end

  test "all product photos should have valid URLs" do
    invalid_urls = []

    Product.all.each do |product|
      next if product.photo.blank?

      begin
        uri = URI.parse(product.photo)

        # Check for valid scheme
        unless uri.scheme&.match?(/^https?$/)
          invalid_urls << {
            product: product.name,
            photo_url: product.photo,
            error: "Invalid URL scheme: #{uri.scheme}"
          }
        end

        # Check for valid host
        if uri.host.blank?
          invalid_urls << {
            product: product.name,
            photo_url: product.photo,
            error: "Missing host"
          }
        end

      rescue URI::InvalidURIError => e
        invalid_urls << {
          product: product.name,
          photo_url: product.photo,
          error: "Invalid URL format: #{e.message}"
        }
      end
    end

    if invalid_urls.any?
      error_message = "Found #{invalid_urls.length} invalid URL(s):\n"
      invalid_urls.each do |invalid_url|
        error_message += "- #{invalid_url[:product]}: #{invalid_url[:photo_url]} (#{invalid_url[:error]})\n"
      end
      flunk error_message
    else
      assert true, "All product photo URLs are valid"
    end
  end

  test "all products should have photos" do
    products_without_photos = Product.where(photo: [ nil, "" ])

    if products_without_photos.any?
      error_message = "Found #{products_without_photos.count} product(s) without photos:\n"
      products_without_photos.each do |product|
        error_message += "- #{product.name} (ID: #{product.id})\n"
      end
      flunk error_message
    else
      assert true, "All products have photos"
    end
  end
end
