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
