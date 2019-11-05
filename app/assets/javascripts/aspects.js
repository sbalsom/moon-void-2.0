function planetSymbol(p) {
    const planets = ['♃', '♄', '♅', '☿', '♇', '♀︎', '♂︎', '☉', '♆']
    switch (p) {
      case "Jupiter": return planets[0]
      case "Saturn": return planets[1]
      case "Uranus": return planets[2]
      case "Mercury": return planets[3]
      case "Pluto": return planets[4]
      case "Venus": return planets[5]
      case "Mars": return planets[6]
      case "Sun": return planets[7]
      case "Neptune": return planets[8]
    }
  }

  function aspectSymbol(d) {
    switch (d) {
      case 0: return "☌"
      case 30: return "semisextile"
      case 60: return "sextile"
      case 90: return "☐"
      case 120: return "△"
      case 180: return "☍"
    }
  }

  function formatAspect(aspect) {
    var degree = parseInt(aspect.replace(/[a-zA-Z]+/, '').trim())
    var planet = aspect.replace(/\d{1,2}/, '').trim()
    return `${aspectSymbol(degree)} ${planetSymbol(planet)}`
  }

  function parse(str) {
    var d = str.substr(0,2),
        m = str.substr(3,2) - 1,
        y = str.substr(6,4),
        h = str.substr(11,2),
        min = str.substr(14,2);
    return Date.UTC(y,m,d,h,min);
  }
  const a = document.querySelector('.aspects')
  const chart = new DOMParser().parseFromString(a.innerText, 'text/html');
  const aspects = chart.getElementsByTagName('tr')
  const aspectBox = document.querySelector('.aspect-message')
 let  n = 2
  for (n = 2; n < aspects.length; n++) {
    let aspectData =  aspects[n].innerText.trim().split('\n')
    let now = new Date()
    let beginStr = aspectData[0].replace(/[A-Z]{1}[a-z]{2}/, '')
    let endStr = aspectData[2].replace(/[A-Z]{1}[a-z]{2}/, '')
    let b = parse(beginStr)
    let e = parse(endStr)
    if (now >= b && now < e) {
      aspectBox.innerText = `Sep. from: ${formatAspect(aspectData[1])}`
    }
  }
