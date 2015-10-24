// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require social-share-button
//= require tinymce
//= require global

var check_for_notifications = function() {
	var offset = $('#notification-data').data('notification-offset');
	$.getJSON('/notifications/' + offset, function(data) {
		$.each(data, function(key, val) {
			switch (key) {
				case 'size':
				$('#notification-data').data('notification-offset', offset + val);
				break;

				case 'notifications':
				$.each(val, function(index, element) {
					var img = 'https://cloud.githubusercontent.com/assets/690017/4317652/8946bb80-3f15-11e4-8b1b-961d47232979.png';
					if (element.icon != '') {
						img = element.icon;
					}

					if (element.points > 0) {
						display_notification(
							'<h4>' + element.notification + '</h4>' + 
							'<h5>You received ' + element.points + ' points</h5>');

						if (!element.popup) {
							$('#notification-container').prepend(
								'<div class="user-notification notification-link" id="' + element.link + '">' +
								'<div id="icon">' +
								'<img src="' + img + '" />' +
								'</div>' +

								'<div id="text">' +
								'<h4>' + element.notification + '</h4>' +
								'<h5>You received: ' + element.points +' points</h5>' +
								'</div>' +
								'</div>');
						}
					} else {
						display_notification('<h3>' + element.notification + '</h3>');

						if (!element.popup) {
							$('#notification-container').prepend(
								'<div class="user-notification notification-link" id="' + element.link + '">' +
								'<div id="icon">' +
								'<img src="' + img + '" />' +
								'</div>' +

								'<div id="text">' +
								'<h4>' + element.notification + '</h4>' +
								'</div>' +
								'</div>');
						}
					}
				});
				break;
			}
		});
	});
};

var timeout;

var display_notification = function(data) {
	$('#notifications').html(data);
	$('#notifications').fadeIn('slow');
	if (timeout) {
		clearTimeout(timeout);
		timeout = null;
	}
	timeout = setTimeout((function() {
		$('#notifications').fadeOut('slow');
	}), 5000);
};

var interval;

var ready = function() {
	setTimeout(check_for_notifications(), 1000);
	if (interval) {
		clearInterval(interval);
		interval = null;
	}
	interval = setInterval(check_for_notifications, 10000);

	$('body').on('click', '#nav-notifications', function() {
		$('#user-notifications').fadeToggle(400);
	});

	$('body').on('click', '.notification-link', function() {
		window.location = this.id;
	});
};

$(document).ready(ready);
$(document).on('page:load', ready);
