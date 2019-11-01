require 'nokogiri'
require 'open-uri'

class MoonsController < ApplicationController
  def main
    url = 'https://www.moontracks.com/void_of_course_moon_dates.html'
    file = open(url)
    doc = Nokogiri::HTML(file)
    @schedule = doc.search("table[style='margin-left:auto; margin-right:auto;width:370px;']")
    other_url = 'https://www.moontracks.com/lunar_ingress.html'
    html = open(other_url)
    doc_two = Nokogiri::HTML(html)
    @ingresses = doc_two.search('table')[2]

  end
end

