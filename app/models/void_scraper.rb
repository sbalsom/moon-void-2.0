require 'nokogiri'
require 'open-uri'
require 'resolv-replace'


class VoidScraper < ApplicationRecord
  def find_schedule
    void_url = 'https://www.moontracks.com/void_of_course_moon_dates.html'
    html = open(void_url)
    doc = Nokogiri::HTML(html)
    table = doc.search('table:contains("Void of Course Schedule")')
    find_aspects
    parse_schedule(table)
    return "done"
  end

  def parse_schedule(table)
    rows = table.search('tr')
    rows.each_with_index do |row, index|
      next if row.text.length > 100
      next unless row.text =~ /Moon\sBegins/

      e = Time.parse(rows[index + 1].children[0].text + ' ' + rows[index + 1].children[1].text + ' UTC') if rows[index + 1]
      es = rows[index + 1].children[3].text if rows[index + 1]
      v = Void.find_or_create_by(
        begin: Time.parse(row.children[0].text + ' ' + row.children[1].text + ' UTC'),
        begin_sign: row.children[3].text
      )
      v.end = e
      v.end_sign = es
      v.aspect = Aspect.all.find { |a| a.begin_void.beginning_of_day == v.begin.beginning_of_day }
      v.save
    end
  end

  def find_aspects
    aspect_url = 'https://astroelite.com/cgi-bin/dispatch.exe?rep=peph&Lng=0'
    html = open(aspect_url)
    doc = Nokogiri::HTML(html)
    rows = doc.search('.Treb table:contains("Void Moon periods")').search('tr')
    rows.each do |row|
      next if row.text =~ /(Start|Void\sMoon\speriods)/

      Aspect.find_or_create_by(
        begin_void: Time.parse(row.search('td')[0].text + " UTC"),
        degree: find_degree(row.search('td')[1].text),
        formatted_degree: format_degree(find_degree(row.search('td')[1].text)),
        planet: find_planet(row.search('td')[1].text),
        formatted_planet: format_planet(find_planet(row.search('td')[1].text)),
        end_void: Time.parse(row.search('td')[2].text + " UTC")
      )
    end
  end

  def find_degree(text)
    text.sub(/[a-zA-Z]+/, '').strip.to_i
  end

  def find_planet(text)
    text.sub(/\d{1,3}/, '').strip
  end

  def format_degree(degree)
    case degree
    when 0 then '☌'
    when 30 then 'semisextile'
    when 60 then 'sextile'
    when 90 then '☐'
    when 120 then '△'
    when 180 then '☍'
    end
  end

  def format_planet(planet)
    planets = ['♃', '♄', '♅', '☿', '♇', '♀︎', '♂︎', '☉', '♆']
    case planet
    when 'Jupiter' then planets[0]
    when 'Saturn' then planets[1]
    when 'Uranus' then planets[2]
    when 'Mercury' then planets[3]
    when 'Pluto' then planets[4]
    when 'Venus' then planets[5]
    when 'Mars' then planets[6]
    when 'Sun' then planets[7]
    when 'Neptune' then planets[8]
    end
  end
end
