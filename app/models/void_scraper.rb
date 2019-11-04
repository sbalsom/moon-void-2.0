require 'nokogiri'
require 'open-uri'

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

      aspect = Aspect.find_or_create_by(
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

# aspect[:begin_void] = Time.parse(row.search('td')[0].text + " UTC")
      # aspect[:degree] = find_degree(row.search('td')[1].text)
      # aspect[:formatted_degree] = format_degree(aspect[:degree])
      # aspect[:planet] = find_planet(row.search('td')[1].text)
      # aspect[:formatted_planet] = format_planet(aspect[:planet])
      # aspect[:end_void] = Time.parse(row.search('td')[2].text + " UTC")
# function planetSymbol(p) {
#     const planets = ['♃', '♄', '♅', '☿', '♇', '♀︎', '♂︎', '☉', '♆']
#     switch (p) {
#       case "Jupiter": return planets[0]
#       case "Saturn": return planets[1]
#       case "Uranus": return planets[2]
#       case "Mercury": return planets[3]
#       case "Pluto": return planets[4]
#       case "Venus": return planets[5]
#       case "Mars": return planets[6]
#       case "Sun": return planets[7]
#       case "Neptune": return planets[8]
#     }
#   }

#   function aspectSymbol(d) {
#     switch (d) {
#       case 0: return "☌"
#       case 30: return "semisextile"
#       case 60: return "sextile"
#       case 90: return "☐"
#       case 120: return "△"
#       case 180: return "☍"
#     }
#   }

#   function formatAspect(aspect) {
#     var degree = parseInt(aspect.replace(/[a-zA-Z]+/, '').trim())
#     var planet = aspect.replace(/\d{1,2}/, '').trim()
#     return `${aspectSymbol(degree)} ${planetSymbol(planet)}`
#   }

#   function parse(str) {
#     var d = str.substr(0,2),
#         m = str.substr(3,2) - 1,
#         y = str.substr(6,4),
#         h = str.substr(11,2),
#         min = str.substr(14,2);
#     return Date.UTC(y,m,d,h,min);
#   }
#   const a = document.querySelector('.aspects')
#   const chart = new DOMParser().parseFromString(a.innerText, 'text/html');
#   const aspects = chart.getElementsByTagName('tr')
#   const aspectBox = document.querySelector('.aspect-message')
#  let  n = 2
#   for (n = 2; n < aspects.length; n++) {
#     let aspectData =  aspects[n].innerText.trim().split('\n')
#     let now = new Date()
#     let beginStr = aspectData[0].replace(/[A-Z]{1}[a-z]{2}/, '')
#     let endStr = aspectData[2].replace(/[A-Z]{1}[a-z]{2}/, '')
#     let b = parse(beginStr)
#     let e = parse(endStr)
#     if (now >= b && now < e) {
#       aspectBox.innerText = `Sep. from: ${formatAspect(aspectData[1])}`
#     }
#   }


 #    t.datetime "begin"
 #    t.datetime "end"
 #    t.string "begin_sign"
 #    t.string "end_sign"
 #    t.datetime "created_at", null: false
 #    t.datetime "updated_at", null: false
 #    t.string "last_sep"

# const cal = []
# let group = {}
# let row = {}

# let lastEnd = 'unset'
# let nextBegin = 'unset'

# let i = 0
#   for (i = 1; i < rows.length - 1; i++) {
#     if (i == 1 && rows[i].innerText.match(/Moon\sEnters/)) {
#       continue;
#     }
#     if (rows[i].innerText.match(/Moon\sBegins/)) {
#       row = {}
#       row['beginVocDate'] = rows[i].children[0].innerText
#       row['beginVocTime'] = rows[i].children[1].innerText
#       group['begin'] = row
#     } else if (rows[i].innerText.match(/Moon\sEnters/)) {
#       row = {}
#       row['endVocDate'] = rows[i].children[0].innerText
#       row['endVocTime'] = rows[i].children[1].innerText
#       group['end'] = row
#       if (Object.keys(group).length === 2) {
#           cal.push(group)
#           group = {}
#       }
#     }
#   }

#   cal.forEach((row, index) => {
#     let beginString = row['begin']['beginVocDate'] + ' ' + row['begin']['beginVocTime'] + " UTC"

#     let endString = row['end']['endVocDate'] + ' ' + row['end']['endVocTime'] + " UTC"
#     let begin = new Date(beginString)
#     let end = new Date(endString)
#     let now = new Date()
#     if (now < begin && nextBegin === 'unset' && voidBox.innerText !== 'Yup.') {
#       nextBegin = begin
#       voidBox.innerText = 'Nope.'
#       document.querySelector('.next-void-message').innerText = `Moon will be void on ${formatDate(nextBegin)} local time.`
#     }
#   })
#   i = cal.length - 1
#   for (cal.length - 1; i >= 0; i--) {
#     let beginString = cal[i]['begin']['beginVocDate'] + ' ' + cal[i]['begin']['beginVocTime'] + " UTC"
#     let endString = cal[i]['end']['endVocDate'] + ' ' + cal[i]['end']['endVocTime'] + " UTC"
#     let begin = new Date(beginString)
#     let end = new Date(endString)
#     let now = new Date()
#     if (now > end && lastEnd === 'unset' && voidBox.innerText !== 'Yup.') {
#       lastEnd = end
#       voidBox.innerText = 'Nope.'
#     }

#     if (now > begin && now < end) {
#       voidBox.innerText = 'Yup.'
#       let d = new Date(cal[i]['begin']['beginVocDate'] + " " + cal[i]['begin']['beginVocTime'] + "+00:00")

#       document.querySelector('.next-void-message').innerText = `Moon turned void on ${formatDate(d)} local time.`
#        let e = new Date(cal[i]['end']['endVocDate'] + " " + cal[i]['end']['endVocTime'] + "+00:00")

#     document.querySelector('.next-void-message').insertAdjacentHTML('afterend', `<h3>Void ends on ${formatDate(e)} local time.</h3>`)
#     }

#   }

