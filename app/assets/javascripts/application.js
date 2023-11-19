//= require rails-ujs
//= require turbolinks
//= require action_cable
//= require jquery3
//= require cocoon
//= require skim
//= require gist-embed/dist/gist-embed.min
//= require_tree .

var App = App || {};
App.cable = ActionCable.createConsumer();
