require 'nokogiri'
require 'open-uri'

class MoonsController < ApplicationController
  def main
    @void = Void.where('voids.begin <= ? and voids.end > ?', Time.now, Time.now).first
    @next_void = Void.where('voids.begin > ?', Time.now)
                     .order(begin: :asc)
                     .first
    @moon = find_moon
  end

  private

  def find_moon
    moon_url = 'https://www.lunarliving.org/'
    html = open(moon_url)
    doc = Nokogiri::HTML(html)
    doc.search('.moon').search('b').text
  end
end

