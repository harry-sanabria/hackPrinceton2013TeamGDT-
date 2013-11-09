$('body').prepend('<div id="fb-root"></div>')

$(function() {
  $.ajaxSetup({ cache: true });
  $.getScript('//connect.facebook.net/en_US/all.js', function(){
    FB.init({
      appId: '389488077848048',
    });
    facebook_token = (document.getElementById("facebook_token").value)
    var groups = new Array();
    FB.api('/me/groups', {access_token: facebook_token}, function(response) {
      alert(JSON.stringify(response));
      groupObjs = eval(reponse)
      for (var i=0; i<groupObjs.length; i++) {
        groups.push('<option value="'+ groupObjs[i].id +'">'+ groupObjs[i].name +'</option>');
      }
    });
    $("#group_select").html(groups.join(''));
 
  });
});
