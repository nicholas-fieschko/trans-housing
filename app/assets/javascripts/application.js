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
//= require jquery.turbolinks
//= require jquery_ujs
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .

handlers = function(){
  $("#user_gender_attributes_identity").click(function(){th.updatePronouns();});
  $("#pronoun-button").click(function(){th.updatePronouns();});
  $("label[for='user_is_provider_true']").first().click(function(){th.updateHelperSeekerStatusText("provider");});
  $("label[for='user_is_provider_false']").first().click(function(){th.updateHelperSeekerStatusText("seeker");});

  $("#binary_genders").blur(function(){th.updateGenderIdentity("#binary_genders");});
  $("#binary_trans_genders").blur(function(){th.updateGenderIdentity("#binary_trans_genders");});
  $("#nonbinary_trans_genders").blur(function(){th.updateGenderIdentity("#nonbinary_trans_genders");});
  
  $("#user_gender_attributes_trans_true").change(function(){th.setGenderSelectOptions(true);});
  $("#user_gender_attributes_trans_false").change(function(){th.setGenderSelectOptions(false);});


};

$(window).on('page:load', function(){ 
  console.log("Loading handlers through 'window on page:load'.");
  handlers();
});
$(window).ready(function(){ 
  console.log("Loading handlers through 'window ready'.");
  handlers();
});