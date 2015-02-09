window.fbAsyncInit = function() {
  FB.init({
    appId      : '820192964704242',
    xfbml      : true,
    version    : 'v2.1'
  });
  FB.getLoginStatus(function(response) {
    if (response.status === 'connected') {
      FB.api('/me', function(response) {;
        document.getElementById('name').innerHTML = response.name;
      });
      return;
    }
  });
};

(function(d, s, id){
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) {return;}
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/sdk.js";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));