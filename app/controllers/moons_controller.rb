require 'nokogiri'
require 'open-uri'

class MoonsController < ApplicationController
  def main
    @schedule = find_schedule
    @aspects = find_aspects
    @moon = find_moon
  end

  private

  # def find_moon2
  #   Moon.last

  #   # sign
  #   # degree_number
  # end

  def find_moon
    moon_url = 'https://www.lunarliving.org/'
    html = open(moon_url)
    doc = Nokogiri::HTML(html)
    doc.search('.moon').search('b').text
  end

  def find_schedule
    # find_or_create_by store five day span of info and always update it on scrape
    # then only need to scrape once a month
    void_url = 'https://www.moontracks.com/void_of_course_moon_dates.html'
    html = open(void_url)
    doc = Nokogiri::HTML(html)
    doc.search("table[style='margin-left:auto; margin-right:auto;width:370px;']")
  end

  def find_aspects
    # should run once a week ?
    aspect_url = 'https://astroelite.com/cgi-bin/dispatch.exe?rep=peph&Lng=0'
    html = open(aspect_url)
    doc = Nokogiri::HTML(html)
    doc.search('.Treb table:contains("Void Moon periods")')
  end
end

