# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.th ?= {}


th.error_messages_general = {
  "username"        : "Please enter your name.",
  "trans-status"    : "Please provide your trans* status.",
  "identity"        : "Please provide your gender.",
  "custom-pronouns" : "Please specify whether these pronouns are correct.",
  "pronouns"        : "Please enter all your correct pronouns or click 'back' to specify not needing them.",
  "contact"         : "Please provide at least one contact method.",
  "location"        : "Please enter a rough estimate of your location--" +
                      " we need it to match you with people nearby who can help.",
  "provider-status" : "Please specify whether you are able to provide"+
                      " resources or are in need of them.",
  # "resources"    Currently no validation requirements.
  "password"        : "Password fields do not match."
}

th.error_messages_by_id = {
  "user_name":                            th.error_messages_general["username"],
  "user_gender_attributes_trans_true"  :  th.error_messages_general["trans-status"],
  "user_gender_attributes_trans_false" :  th.error_messages_general["trans-status"],
  "user_gender_attributes_identity"    :  th.error_messages_general["identity"],
  "binary_genders"                     :  th.error_messages_general["identity"],
  "binary_trans_genders"               :  th.error_messages_general["identity"],
  "nonbinary_trans_genders"            :  th.error_messages_general["identity"],
  "user_gender_attributes_cp_false"    :  th.error_messages_general["custom-pronouns"],
  "user_gender_attributes_cp_true"     :  th.error_messages_general["custom-pronouns"],
  "user_gender_attributes_they"        :  th.error_messages_general["pronouns"],
  "user_gender_attributes_their"       :  th.error_messages_general["pronouns"],
  "user_gender_attributes_them"        :  th.error_messages_general["pronouns"],
  "user_contact_attributes_email"      :  th.error_messages_general["contact"],
  "user_contact_attributes_phone"      :  th.error_messages_general["contact"],
  "user_location_attributes_zip"       :  th.error_messages_general["location"],
  "user_location_attributes_city"      :  th.error_messages_general["location"],
  "user_location_attributes_state"     :  th.error_messages_general["location"],
  "user_is_provider_true"              :  th.error_messages_general["provider-status"],
  "user_is_provider_false"             :  th.error_messages_general["provider-status"],
  # Currently no validation requirement for resources.
  # "user_food_resource_attributes_currently_offered_true"
  # "user_food_resource_attributes_currently_offered_false"
  # "user_shower_resource_attributes_currently_offered_true"
  # "user_shower_resource_attributes_currently_offered_false"
  # "user_laundry_resource_attributes_currently_offered_true"
  # "user_laundry_resource_attributes_currently_offered_false"
  # "user_housing_resource_attributes_currently_offered_true"
  # "user_housing_resource_attributes_currently_offered_false"
  # "user_transportation_resource_attributes_currently_offered_true"
  # "user_transportation_resource_attributes_currently_offered_false"
  # "user_buddy_resource_attributes_currently_offered_true"
  # "user_buddy_resource_attributes_currently_offered_false"
  "user_password"                      :  th.error_messages_general["password"],
  "user_password_confirmation"         :  th.error_messages_general["password"]
}


th.insert_error_for = (field) -> 
  if $(".input-error").length == 0
    $("<span class='input-error' id='#{field}-error'>" +
      "<i class='fa fa-exclamation-circle'></i>"       +
      "#{th.error_messages_by_id[field]}"                       +
      "</span>")
      .insertBefore($("##{field}").parents("form"))

th.validateAndAdvance = (obj) ->
  # Advances wizard with directions [[from, to],[from,to],...] 
  # after validating field with id specified.
  field_id = obj[0].id.replace '_button',''
  field_invalid = th.validateField field_id

  # end_of_form = false

  if field_invalid
    th.insert_error_for field_id
  else
    $(".input-error").remove()
    switch field_id
      when "user_name"
        th.advanceWizard(1,2)
        th.advanceWizard(0,'g-1')
      when "user_gender_attributes_trans_true", "user_gender_attributes_trans_false"
        th.advanceWizard('g-1','g-2')
      when "user_gender_attributes_identity","binary_genders","binary_trans_genders","nonbinary_trans_genders"
        th.advanceWhereDecision('g-2')
      when "user_gender_attributes_cp_false","user_gender_attributes_cp_true"
        th.advanceWhereDecision('g-3')
      when "user_gender_attributes_they","user_gender_attributes_their","user_gender_attributes_them"
        th.advanceWizard('g-4','3')
      when "user_contact_attributes_email","user_contact_attributes_phone"
        th.advanceWizard('3','4')
        google.maps.event.trigger(map, "resize")
      when "user_location_attributes_zip","user_location_attributes_city","user_location_attributes_state"
        th.advanceWizard('4','5')
      when "user_is_provider_true","user_is_provider_false"
        th.advanceWizard('5','6')
      when "user_food_resource_attributes_currently_offered_true","user_food_resource_attributes_currently_offered_false","user_shower_resource_attributes_currently_offered_true","user_shower_resource_attributes_currently_offered_false","user_laundry_resource_attributes_currently_offered_true","user_laundry_resource_attributes_currently_offered_false","user_housing_resource_attributes_currently_offered_true","user_housing_resource_attributes_currently_offered_false","user_transportation_resource_attributes_currently_offered_true","user_transportation_resource_attributes_currently_offered_false","user_buddy_resource_attributes_currently_offered_true","user_buddy_resource_attributes_currently_offered_false"
        th.advanceWizard('6','7')
      when "user_password", "user_password_confirmation"
        $("#submit_signup").click()
        # end_of_form = true

  # return end_of_form


th.validateField = (field_id) ->
  field = $("##{field_id}")
  was_error = false

  switch field_id
    when "user_name"
      if field.val() == ''
        was_error = true
    when "user_gender_attributes_trans_true", "user_gender_attributes_trans_false"
      if !$("#user_gender_attributes_trans_true").is(':checked') &&
         !$("#user_gender_attributes_trans_false").is(':checked')
        was_error = true
    when "user_gender_attributes_identity","binary_genders","binary_trans_genders","nonbinary_trans_genders"
      # If user selects nothing, it just takes default select value. No validation necessary.
      was_error = false
    when "user_gender_attributes_cp_false","user_gender_attributes_cp_true"
      # Although this field is not required in some pathways through the form,
      # if they are on this page, they need to answer.
      if !$("#user_gender_attributes_cp_false").is(':checked') &&
         !$("#user_gender_attributes_cp_true").is(':checked')
        was_error = true
    when "user_gender_attributes_they","user_gender_attributes_their","user_gender_attributes_them"
      if $("#user_gender_attributes_they").val()  == '' ||
         $("#user_gender_attributes_their").val() == '' ||
         $("#user_gender_attributes_them").val()  == ''
        was_error = true
    when "user_contact_attributes_email","user_contact_attributes_phone"
      if $("#user_contact_attributes_email").val() == '' &&
         $("#user_contact_attributes_phone").val() == ''
        was_error = true
    when "user_location_attributes_zip","user_location_attributes_city","user_location_attributes_state"
      if $("#user_location_attributes_zip").val()  == '' ||
         $("#user_location_attributes_city").val() == '' ||
         $("#user_location_attributes_state").val()  == ''
        was_error = true
    when "user_is_provider_true","user_is_provider_false"
      if !$("#user_is_provider_true").is(':checked') &&
         !$("#user_is_provider_false").is(':checked')
        was_error = true
    when "user_food_resource_attributes_currently_offered_true","user_food_resource_attributes_currently_offered_false","user_shower_resource_attributes_currently_offered_true","user_shower_resource_attributes_currently_offered_false","user_laundry_resource_attributes_currently_offered_true","user_laundry_resource_attributes_currently_offered_false","user_housing_resource_attributes_currently_offered_true","user_housing_resource_attributes_currently_offered_false","user_transportation_resource_attributes_currently_offered_true","user_transportation_resource_attributes_currently_offered_false","user_buddy_resource_attributes_currently_offered_true","user_buddy_resource_attributes_currently_offered_false"
      # No validation on this currently.
      was_error = false
    when "user_password", "user_password_confirmation"
      if $("#user_password").val() != $("#user_password_confirmation").val()
        was_error = true
    # else
      # console.error "Unknown field."
      # was_error = true
  return was_error



th.clickNext = (current_field_id) ->
  $("##{current_field_id}").parents(".wizard-current").find(".wizard-forward").click()

th.advanceWhereDecision = (coming_from) ->
  if coming_from == 'g-2'
    if $("#user_gender_attributes_trans_true").is(':checked')
      th.advanceWizard('g-2','g-3')
    else
      th.advanceWizard('g-2','3')
  else if coming_from == 'g-3'
    if $("#user_gender_attributes_cp_true").is(':checked')
      th.advanceWizard('g-3','g-4')
    else
      th.advanceWizard('g-3','3')
  else if coming_from == '3'
    if $("#user_gender_attributes_cp_true").is(':checked')
      th.advanceWizard('3','g-4')
    else if $("#user_gender_attributes_trans_true").is(':checked') 
      th.advanceWizard('3','g-3')
    else
      th.advanceWizard('3','g-2')


th.updateGenderIdentity = (id) ->
  newGender = $("#{id}").val()
  if newGender == "Nonbinary"
    $("#binary_trans_genders").hide()
    $("#nonbinary_trans_genders").show()
    newGender = $("#nonbinary_trans_genders").val()
  if newGender == "Just let me type it!"
    newGender = ''
    $("#nonbinary_trans_genders").hide()
    $("#user_gender_attributes_identity").show()
  $("#user_gender_attributes_identity").val(newGender)

th.setGenderSelectOptions = (is_trans) ->
  if is_trans
    $("#binary_genders").hide()
    $("#binary_trans_genders").show()
  else
    th.clearPronouns()
    $("#nonbinary_trans_genders").hide()
    $("#user_gender_attributes_identity").val($("#binary_genders").val())
    $("#binary_genders").show()
    $("#binary_trans_genders").hide()

th.clearPronouns = ->
  $("#user_gender_attributes_they").val('')
  $("#user_gender_attributes_them").val('')
  $("#user_gender_attributes_their").val('')

th.advanceWizard = (from,to) -> 
  $(".step-#{from}").removeClass "wizard-current"
  $(".step-#{to}").addClass "wizard-current"

th.advanceMiniWizard = (letter,from,to) -> 
  $(".step-#{letter}-#{from}").removeClass "wizard-current"
  $(".step-#{letter}-#{to}").addClass "wizard-current"

th.updateHelperSeekerStatusText = (status) ->
  if status == "seeker"
    $("#seeker-status-text").text "What could be helpful to you?"  
  if status == "provider"
    $("#seeker-status-text").text "What can you do to help?"  

th.updatePronouns = ->
  gender = $("#user_gender_attributes_identity").val()
  $("#they").text("\"#{th.pronoun.they(gender)}\",")
  $("#them").text("\"#{th.pronoun.them(gender)}\",")
  $("#their").text("\"#{th.pronoun.their(gender)}\"?")

th.pronoun =
  they: (gender) -> 
    switch gender.toLowerCase()
      when "female" then "she"
      when "male" then "he"
      else "they"
      
  their: (gender) ->
    switch gender.toLowerCase()
      when "female" then "her"
      when "male" then "his"
      else "their"
          
  them: (gender) ->
    switch gender.toLowerCase()
     when "female" then "her"
     when "male" then "him"
     else "them"