# set the date we're counting down to
target_date = new Date('Jan, 31, 2014').getTime()

# variables for time units
days = undefined
hours = undefined
minutes = undefined
seconds = undefined

# get tag element
countdown = document.getElementById('countdown')

# update the tag with id "countdown" every 1 second
setInterval (->

  # find the amount of "seconds" between now and target
  current_date = (new Date).getTime()
  seconds_left = (target_date - current_date) / 1000
  
  # do some time calculations
  days = parseInt(seconds_left / 86400)
  seconds_left = seconds_left % 86400
  hours = parseInt(seconds_left / 3600)
  seconds_left = seconds_left % 3600
  minutes = parseInt(seconds_left / 60)
  seconds = parseInt(seconds_left % 60)
  # format countdown string + set tag value
  countdown.innerHTML = '<span class="days">' + days + ' <b>Days</b></span> <span class="hours">' + hours + ' <b>Hours</b></span> <span class="minutes">' + minutes + ' <b>Minutes</b></span> <span class="seconds">' + seconds + ' <b>Seconds</b></span>'
  return
), 1000