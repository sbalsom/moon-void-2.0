require 'nokogiri'
require 'open-uri'

class MoonsController < ApplicationController
  def main
    url = 'https://www.moontracks.com/void_of_course_moon_dates.html'
    file = open(url)
    doc = Nokogiri::HTML(file)
    @schedule = doc.search("table[style='margin-left:auto; margin-right:auto;width:370px;']")
    # .search('tr').children
    # calendar = []
    # table.each do |tr|

    other_url = 'https://www.moontracks.com/lunar_ingress.html'
    html = open(other_url)
    doc_two = Nokogiri::HTML(html)
    @ingresses = doc_two.search('table')[2]
    # @thing = thing.search('tr[valign="top"]')

    # end
    # respond_to do |format|
    #   format.js.erb
    # end


  end
end


# const cal = []
#         let group = []
#         let row = []
#         axios(url)
#           .then(response => {
#             const html = response.data
#             const $ = cheerio.load(html)
#             $('table tr').each((i, el) => {
#               if ($(el).text().match(/Moon\sBegins/) && $(el).text().length < 50) {
#                 row = {}
#                 row['beginVocDate'] = $(el).children().eq(0).text()
#                 row['beginVocTime'] = $(el).children().eq(1).text()
#                 row['beginVocSign'] = $(el).children().eq(3).text()
#                 group.push(row)
#               } else if ($(el).text().match(/Moon\sEnters/) && $(el).text().length < 50) {
#                 row = {}
#                 row['endVocDate'] = $(el).children().eq(0).text()
#                 row['endVocTime'] = $(el).children().eq(1).text()
#                 row['endVocSign'] = $(el).children().eq(3).text()
#                 group.push(row)
#                 if (group.length === 2) {
#                   cal.push(group)
#                   group = []
#                 }
#               }
#             })
#             context.commit('set_cal', cal)
#             context.commit('set_void')
#             resolve()
#           })
#       })
#         .catch(console.error)
#     }
