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
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree ../../../vendor/assets/javascripts/.

// テキストエリアの高さ自動調整
$(document).on('turbolinks:load', function () {
  $("textarea").attr("rows", 3).on({
    // inputしたとき
    "input": function (e) {
      $(e.target).height(0).innerHeight(e.target.scrollHeight);
    },
    // clickしたとき
    "click": function (e) {
      $(e.target).height(0).innerHeight(e.target.scrollHeight);
    }
  });
});