$('body').prepend('<div id="fb-root"></div>')
$(function() {
  $.ajaxSetup({ cache: true });
  $.getScript('//connect.facebook.net/en_US/all.js', function(){
    FB.init({
      appId: '389488077848048',
    });
    facebook_token = (document.getElementById("facebook_token"))
    if (facebook_token) {
      var groups = new Array();
      FB.api('/me/groups', {access_token: facebook_token.value}, function(response) {
        groupObjs = eval(response)["data"];
        for (var i=0; i<groupObjs.length; i++) {
          groups.push('<option value="'+ groupObjs[i]["id"] +'">'+ groupObjs[i]["name"] +'</option>');
        }
        $("#group_select").html(groups.join(''));
      });
    }
    confirmation_page_id = (document.getElementById("confirmation_purchase_id"));
    group_id = (document.getElementById("group_id"));
    confirmation_page_token = (document.getElementById("confirmation_page_token"));
    alert("this is: "+group_id.value);
    if (confirmation_page_id && group_id && confirmation_page_token) {
      alert("im here");
      message = "Hey guys!  Join my payment on GroupBuy!";
      link = "http://localhost:3000/purchases/"+confirmation_page_id.value;
      FB.api('/'+group_id.value+'/feed', 'post', {access_token: confirmation_page_token.value, link: link, message: message})
    }
  });
});