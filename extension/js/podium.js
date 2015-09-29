var kickstarter = 'kickstarter.com';
var indiegogo = 'indiegogo.com';

var urlregex = new RegExp('^(http|https)://([a-zA-Z0-9.-]+(:[a-zA-Z0-9.&amp;%$-]+)*@)*(([a-zA-Z0-9-]+.)*[a-zA-Z0-9-]+.(com|net|org|[a-zA-Z]{2}))');

var scope = 'http://stianerkul.me/';

$.embedly.defaults.key = '0eef325249694df490605b1fd29147f5';

$(document).ready(function() {
	$('#nominate').attr('disabled', true);

	checkUserStatus();
	checkStatus();

	$('#nominate').on('click', function() {
		nominate();
	});
});

function checkUserStatus() {
	$.get(scope + 'users/current_user', function(data) {
		$.each(data, function(key, val) {
			switch (key) {
				case 'Name':
					$('#name').html(val);
					break;
				case 'Image':
					$('#image').attr('src', val);
					break;
			}
		});
	});
}

function checkStatus() {
	chrome.tabs.getSelected(null,function(tab) {
		var url = tab.url;
		if (!urlregex.test(url)) {
			return;
		}

		url = url.replace('https://', '');
		url = url.replace('http://', '');

		var splitSlashes = url.split('\/');

		if (new RegExp(kickstarter).test(url)) {
			if (!splitSlashes[1].includes('projects')) {
				$('#status').html('Unsupported site/campaign.');
				return;
			}
			var removeParams = splitSlashes[3].split('?');
			var title = removeParams[0];
			checkCampaignStatus(title);
			return;
		}

		if (new RegExp(indiegogo).test(url)) {
			if (!splitSlashes[1].includes('projects')) {
				$('#status').html('Unsupported site/campaign.');
				return;
			}
			var removeParams = splitSlashes[2].split('#');
			var title = removeParams[0];
			checkCampaignStatus(title);
			return;
		}

		$('#status').html('Unsupported site/campaign.');
		$.get(scope + 'campaigns/log/' + splitSlashes[0], function(data) {});
	});
}

function checkCampaignStatus(title) {
	$.get(scope + 'campaigns/checkIfCanAdd/' + title, function(data) {
		$.each(data, function(key, val) {
			console.log(key + ": " + val);
			switch (key) {
				case 'Campaign':
					switch(val) {
						case 'nominated: true':
							$('#status').html('Nominated');
							$('#nominate').attr('disabled', true);
							break;

						case 'nominated: false':
							$('#status').html('Not yet nominated');
							$('#nominate').attr('disabled', false);
							break;

						case 'was not found':
							$('#status').html('Not yet nominated');
							$('#nominate').attr('disabled', false);
							break;
					}
					break;

				case 'User':
					switch(val) {
						case 'not logged in':
							$('#status').html('You are not logged in');
							$('#nominate').attr('disabled', true);
							break;

						case 'too many campaigns nominated':
							$('#status').html('You have already nominated your three nominations for today!');
							$('#nominate').attr('disabled', true);
							break;
					}
					break;
			}
		});
	});
}

function nominate() {
	chrome.tabs.getSelected(null, function(tab) {
		var url = tab.url;
		switch ($('#status').html()) {
			case 'Not yet nominated':
				$('#status').html('Nominating...');
				$('#nominate').attr('disabled', true);
				nominateCampaign(url);
				break;

			default:
				break;
		}
	});
}

function nominateCampaign(url) {
	var request = new XMLHttpRequest();
	request.open('POST', scope + 'campaigns', /* async = */ true);

	request.onreadystatechange = function() {
		if (request.readyState == 4) {
			setTimeout(checkStatus(), 2000);
		}
	}

	var formData = new FormData();
	formData.append('campaign[link]', url);
	formData.append('campaign[category_id]', 1);

	request.send(formData);
}
