function formatDate(date) {
  var monthNames = [
    "January", "February", "March",
    "April", "May", "June", "July",
    "August", "September", "October",
    "November", "December"
  ];

  var day = date.getDate();
  var monthIndex = date.getMonth();
  var year = date.getFullYear();
  var hour = date.getHours();
  var minutes = date.getMinutes();
  if (minutes < 10) {
    minutes = `0${minutes}`
  }
  if (hour < 10) {
    hour = `0${hour}`
  }
  return `${day} ${monthNames[monthIndex]} ${year} at ${hour}:${minutes}`;
}

const voidBox = document.querySelector('.void-message')
const c = document.querySelector('.schedule')
const table = new DOMParser().parseFromString(c.innerText, 'text/html');
const rows = table.getElementsByTagName('tr')

const cal = []
let group = {}
let row = {}

let lastEnd = 'unset'
let nextBegin = 'unset'

let i = 0
  for (i = 1; i < rows.length - 1; i++) {
    if (i == 1 && rows[i].innerText.match(/Moon\sEnters/)) {
      continue;
    }
    if (rows[i].innerText.match(/Moon\sBegins/)) {
      row = {}
      row['beginVocDate'] = rows[i].children[0].innerText
      row['beginVocTime'] = rows[i].children[1].innerText
      group['begin'] = row
    } else if (rows[i].innerText.match(/Moon\sEnters/)) {
      row = {}
      row['endVocDate'] = rows[i].children[0].innerText
      row['endVocTime'] = rows[i].children[1].innerText
      group['end'] = row
      if (Object.keys(group).length === 2) {
          cal.push(group)
          group = {}
      }
    }
  }

  cal.forEach((row, index) => {
    let beginString = row['begin']['beginVocDate'] + ' ' + row['begin']['beginVocTime'] + " UTC"

    let endString = row['end']['endVocDate'] + ' ' + row['end']['endVocTime'] + " UTC"
    let begin = new Date(beginString)
    let end = new Date(endString)
    let now = new Date()
    if (now < begin && nextBegin === 'unset' && voidBox.innerText !== 'Yup.') {
      nextBegin = begin
      voidBox.innerText = 'Nope.'
      document.querySelector('.next-void-message').innerText = `Moon will be void on ${formatDate(nextBegin)} local time.`
    }
  })
  i = cal.length - 1
  for (cal.length - 1; i >= 0; i--) {
    let beginString = cal[i]['begin']['beginVocDate'] + ' ' + cal[i]['begin']['beginVocTime'] + " UTC"
    let endString = cal[i]['end']['endVocDate'] + ' ' + cal[i]['end']['endVocTime'] + " UTC"
    let begin = new Date(beginString)
    let end = new Date(endString)
    let now = new Date()
    if (now > end && lastEnd === 'unset' && voidBox.innerText !== 'Yup.') {
      lastEnd = end
      voidBox.innerText = 'Nope.'
    }

    if (now > begin && now < end) {
      voidBox.innerText = 'Yup.'
      let d = new Date(cal[i]['begin']['beginVocDate'] + " " + cal[i]['begin']['beginVocTime'] + "+00:00")

      document.querySelector('.next-void-message').innerText = `Moon turned void on ${formatDate(d)} local time.`
       let e = new Date(cal[i]['end']['endVocDate'] + " " + cal[i]['end']['endVocTime'] + "+00:00")
       console.log(e)
    document.querySelector('.next-void-message').insertAdjacentHTML('afterend', `<h3>Void ends on ${formatDate(e)} local time.</h3>`)
    }

  }
