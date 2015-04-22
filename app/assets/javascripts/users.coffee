# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.th ?= {}

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
    $("#binary_genders").show()
    $("#binary_trans_genders").hide()

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