# frozen_string_literal: true

require 'net/http'
require 'json'
require 'dotenv'

Dotenv.load

class RenderForm
  def initialize(report)
    @report = report
    @url = URI('https://get.renderform.io/api/v2/render')
    @key = ENV.fetch('RENDER_FORM_API_KEY', nil)
    @template = ENV.fetch('RENDER_FORM_TEMPLATE_ID', nil)
  end

  def generate_image
    @req = Net::HTTP::Post.new(@url)
    prepare_headers
    parse_payload

    Net::HTTP.start(@url.hostname, @url.port, request_options) { |http| http.request(@req) }
  end

  private

  def prepare_headers
    @req.content_type = 'application/json'
    @req['X-API-KEY'] = @key
  end

  def parse_payload
    data = {
      'event_link.text': @report[:event_link],
      'format.text': @report[:format],
      'date.text': @report[:date]
    }

    @report[:players].each do |player|
      data["player#{player[:rank]}.text"] = player[:player]
      data["deck#{player[:rank]}.text"] = player[:deck]
    end

    @req.body = { data:, template: @template }.to_json
  end

  def request_options
    { use_ssl: @url.scheme == 'https' }
  end
end
