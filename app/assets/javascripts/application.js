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

// Makes notice messages disappear after a couple of seconds
window.setTimeout((function() {
	$('#notice').fadeTo(500, 0).slideUp(500, function() {
		$(this).remove();
	});
}), 3000);

var check_for_notifications = function() {
	$.get('/notifications', function(data) {
		if (data) {
			$('#notifications').html(data);
			$('#notifications').fadeIn('slow');
			window.setTimeout((function() {
				$('#notifications').fadeOut('slow');
			}), 5000);
		}
	});
};

$(document).ready(function() {
	setInterval(check_for_notifications, 10000);
});
