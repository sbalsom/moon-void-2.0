require 'nokogiri'
require 'open-uri'

class VoidScraper < ApplicationRecord

  def find_schedule
    void_url = 'https://www.moontracks.com/void_of_course_moon_dates.html'
    html = open(void_url)
    doc = Nokogiri::HTML(html)
    table = doc.search('table:contains("Void of Course Schedule")')
    cal = parse_schedule(table)
    make_voids(cal)
  end

  def parse_schedule(table)
    #  here I could also find the last separating aspect and add it to group
    rows = parse_rows(table)
    group = {}
    cal = []
    rows.shift if rows[0][:type] == 'end'
    rows.each do |r|
      if r[:type] == 'begin'
        group[:begin] = r
      elsif r[:type] == 'end'
        group[:end] = r
      end
      if group.keys.length == 2
        cal << group
        group = {}
      end
    end
    cal
  end

  def parse_rows(table)
    rows = []
    table.search('tr').each do |row|
      void = {}
      next if row.text =~ /Void\sof\sCourse\sSchedule/
      next if row.text.length > 100
      next if row.text =~ /DateUTC\s?\(\+0\)ActivitySign/
      next unless row.text =~ /(Moon\sEnters|Moon\sBegins)/

      void[:date] = Time.parse(row.children[0].text + row.children[1].text + " UTC")
      void[:sign] = row.children[2].text
      if row.text =~ /Moon\sEnters/
        void[:type] = 'end'
      elsif row.text =~ /Moon\sBegins/
        void[:type] = 'begin'
      end
      rows << void
    end
    rows
  end

  def make_voids(cal)
    cal.each do |group|
      Void.find_or_create_by(
        begin: group[:begin][:date],
        end: group[:end][:date],
        begin_sign: group[:begin][:sign],
        end_sign: group[:end][:sign]
      )
    end
    Void.all
  end
end

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
