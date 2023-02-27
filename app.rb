# frozen_string_literal: true

require 'mtgtop8_scrapper'
require 'json'
require_relative 'lib/render_form'

links = [
  'https://www.mtgtop8.com/event?e=40672&d=502476&f=PI'
]

reports = links.map do |link|
  scrapper = MTGTop8Scrapper.new(link)
  scrapper.generate_report

  scrapper.report
end

reports.each do |report|
  response = RenderForm.new(report).generate_image
  if response.is_a? Net::HTTPSuccess
    link = JSON.parse(response.body)['href']

    puts 'Enjoy your amazing image! ✨✨✨'
    puts link
  else
    puts 'Ouuupppss, something wrong happened! Check the error!'
    puts response.message
  end
end
