// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery
//= require popper
//= require bootstrap-sprockets
//= require bootstrap
//= require iziModal.min
//= require_tree .


$(document).on('turbolinks:load', function(){

  $('#modal-default').iziModal({
    fullscreen: false,
    openFullscreen: true,
    closeOnEscape: false,
    closeButton: false
  });
  $('#modal-default').iziModal('open');


  $('#modal-alert').iziModal({
    headerColor: '#d43838',
    // width: 400,
    timeout: 5000,
    pauseOnHover: true,
    timeoutProgressbar: true,
    bottom: 0
    // attached: 'bottom'
  });
});
