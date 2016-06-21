// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require cocoon
//= require moment
//= require bootstrap-datetimepicker
//= require pickers
//= require pt-br
//= require_self
//= require_tree .

//////////////// Thanks Jonatan Klosko! ///////////////////
// Executes the given function on the specified page/pages.
// Requires body to have class '<controller>#<action>'.
// The given pageSelector should have a format: '<controller>#<action>'.
// Could be followed by comma and another pageSelector.
// Example: 'users#show, users#edit, users#update, sessions#new'.
function onPage(pageSelector, fun) {
  pageSelector = pageSelector.replace(/, /g, ',.')
                             .replace(/ /g, '.')
                             .replace(/^/, '.');
  $(document).on('page:change', function() {
    if ($(pageSelector).length > 0) {
      fun();
    }
  });
}


// Executes the given function on every page.
function onEveryPage(fun) {
  $(document).on('page:change', fun);
}

moment.locale('pt-BR');

$(function() {
  $datetimepicker = $('.date_picker.form-control, .datetime_picker.form-control');
  $datetimepicker.each(function() {
    var $this = $(this);
    var datetimepickerOptions = {
      useStrict: true,
      keepInvalid: true,
      useCurrent: false,
      sideBySide: true,
    };
    $this.datetimepicker(datetimepickerOptions);
  });

  $('[data-toggle="tooltip"]').tooltip()
});
