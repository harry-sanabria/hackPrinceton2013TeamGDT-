$(function() {
  alert("hi there");
  facebook_id = (document.getElementById("facebook_id").value)
  var groups = new Array();
  FB.api('/me/groups', function(response) {
      alert("got it");
      groupObjs = eval(reponse)
      for (var i=0; i<groupObjs.length; i++) {
        groups.push('<option value="'+ groupObjs[i].id +'">'+ groupObjs[i].name +'</option>');
      }
    });
  $("#group_select").html(groups.join('');
});
