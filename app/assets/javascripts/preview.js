$(function () {
  var input = $('textarea');
  var value = $(input).val();
  $('#editor').html(marked(value));
  $(input).on('input', function (event) {
    var value = $(input).val();
    $('#editor').html(marked(value));
  });
});