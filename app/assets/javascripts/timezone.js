var offset = new Date().getTimezoneOffset();
const offsetHours = -offset/60;
const timeZoneDisplay = document.querySelector('.timezone-display');

function setTimeZone (offsetHours) {
    if (offsetHours > 0) {
      timeZoneDisplay.innerText = `+${offsetHours}:00`
    } else if (offsetHours < 0) {
      timeZoneDisplay.innerText = `-${offsetHours}:00`
    } else {
      timeZoneDisplay.innerText = `+00:00`
    }
  }

setTimeZone(offsetHours);



let lastVoid = document.querySelector('.last-void');
if (lastVoid != null) {
  lastVoid = lastVoid.innerText
  lastVoid = new Date('1970-01-01T' + lastVoid)
  lastVoid.setHours(lastVoid.getHours() + offsetHours);

}

let nextEnd = document.querySelector('.next-end');
if (nextEnd != null) {
  nextEnd = nextEnd.innerText
  nextEnd = new Date('1970-01-01T' + nextEnd)
  nextEnd.setHours(nextEnd.getHours() + offsetHours);
}

let nextVoid = document.querySelector('.next-void')
if (nextVoid != null) {
  nextVoid = nextVoid.innerText;
  nextVoid = new Date('1970-01-01T' + nextVoid)
  nextVoid.setHours(nextVoid.getHours() + offsetHours);
}


  const lastSlot = document.querySelector('.calculated-last');
  if (lastSlot != null && lastVoid != null) {
    let lastHours = (lastVoid.getHours()<10?'0':'') + lastVoid.getHours()
    let lastMinutes = (lastVoid.getMinutes()<10?'0':'') + lastVoid.getMinutes()
    lastSlot.innerText = `${lastHours}:${lastMinutes}`
  }

  const endSlot = document.querySelector('.calculated-end');
  if (endSlot != null && nextEnd != null) {
    let endHours = (nextEnd.getHours()<10?'0':'') + nextEnd.getHours()
    let endMinutes = (nextEnd.getMinutes()<10?'0':'') + nextEnd.getMinutes()
    endSlot.innerText = `${endHours}:${endMinutes}`
  }
 const nextSlot = document.querySelector('.calculated-next');
  if (nextSlot != null && nextVoid != null) {
    let nextHours = (nextVoid.getHours()<10?'0':'') + nextVoid.getHours()
    let nextMinutes = (nextVoid.getMinutes()<10?'0':'') + nextVoid.getMinutes()
    nextSlot.innerText = `${nextHours}:${nextMinutes}`
  }


