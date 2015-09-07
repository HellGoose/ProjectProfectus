var validURLs = ['kickstarter.com', 'indiegogo.com'];
var urlregex = new RegExp('^(http|https)://([a-zA-Z0-9.-]+(:[a-zA-Z0-9.&amp;%$-]+)*@)*(([a-zA-Z0-9-]+.)*[a-zA-Z0-9-]+.(com|net|org|[a-zA-Z]{2}))');

var scope = 'http://localhost:5000/';

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
		if (urlregex.test(url) && new RegExp(validURLs.join("|")).test(url)) {
			$.embedly.extract(url).progress(function(campaignData) {
				campaignData.title = campaignData.title.replace('CLICK HERE to support ', '');
				campaignData.title = encodeURIComponent(campaignData.title).replace(/\./g, '');
				$.get(scope + 'campaigns/checkIfCanAdd/' + campaignData.title, function(data) {
					$.each(data, function(key, val) {
						console.log(key + ", " + val);
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
										$('#status').html('You have nominated too many campaigns this round');
										$('#nominate').attr('disabled', true);
										break;
								}
								break;
						}
					});
				});
			});
		} else {
			$('#status').html('Unsupported site');
		}
	});
}

function nominate() {
	$('#status').html('Nominating...');
	chrome.tabs.getSelected(null, function(tab) {
		var url = tab.url;
		if (urlregex.test(url) && new RegExp(validURLs.join("|")).test(url)) {
			$.embedly.extract(url).progress(function(campaignData) {
				campaignData.title = campaignData.title.replace('CLICK HERE to support ', '');
				campaignData.title = encodeURIComponent(campaignData.title).replace(/\./g, '');
				$.get(scope + 'campaigns/checkIfCanAdd/' + campaignData.title, function(data) {
					$.each(data, function(key, val) {
						switch (key) {
							case 'Campaign':
								switch(val) {
									case 'nominated: true':
										break;

									case 'nominated: false':
										nominateCampaign(url, campaignData);
										break;

									case 'was not found':
										nominateCampaign(url, campaignData);
										break;
								}
								break;

							case 'User':
								switch(val) {
									case 'not logged in':
										break;

									case 'too many campaigns nominated':
										break;
								}
								break;
						}
					});
				});
			});
		}
	});
}

function nominateCampaign(url, campaign) {
	$('#nominate').attr('disabled', true);

	var request = new XMLHttpRequest();
	request.open('POST', scope + 'campaigns', /* async = */ true);

	request.onreadystatechange = function() {
		if (request.readyState == 4) {
			checkStatus();
		}
	}

	var formData = new FormData();
	formData.append('campaign[link]', url);
	formData.append('campaign[category_id]', 1);
	formData.append('campaign[description]', campaign.description);
	formData.append('campaign[title]', campaign.title);
	formData.append('campaign[image]', campaign.images[0].url);

	request.send(formData);
}
