var validURLs = ['kickstarter.com', 'indiegogo.com'];
var urlregex = new RegExp('^(http|https)://([a-zA-Z0-9.-]+(:[a-zA-Z0-9.&amp;%$-]+)*@)*(([a-zA-Z0-9-]+.)*[a-zA-Z0-9-]+.(com|net|org|[a-zA-Z]{2}))');

var scope = 'http://stianerkul.me/';

$.embedly.defaults.key = '0eef325249694df490605b1fd29147f5';

$(document).ready(function() {
	$("#test").html("Jalla");
	//scrapeURL('https://www.kickstarter.com/projects/840857675/the-2015-larb-summer-interns-publish-their-own-mag?ref=home_potd');
	//checkIfInScope();
	checkIfCanNominate();
});

function checkIfCanNominate() {
	chrome.tabs.getSelected(null,function(tab) {
		var url = tab.url;
		if (urlregex.test(url) && new RegExp(validURLs.join("|")).test(url)) {
			$.embedly.extract(url).progress(function(campaignData) {
				campaignData.title = campaignData.title.replace('CLICK HERE to support ', '');
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
	var request = new XMLHttpRequest();
	request.open('POST', scope + 'campaigns', /* async = */ false);

	var formData = new FormData();
	formData.append('campaign[link]', url);
	formData.append('campaign[category_id]', 1);
	formData.append('campaign[description]', campaign.description);
	formData.append('campaign[title]', campaign.title);
	formData.append('campaign[image]', campaign.images[0].url);

	request.send(formData);
	console.log(request.response);
}
