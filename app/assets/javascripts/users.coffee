# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.th ?= {}

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