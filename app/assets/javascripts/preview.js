$(function () {
  var input = $('textarea');
  var value = $(input).val();
  $('#editor').html(marked(value));
  $(input).on('input', function (event) {
    $('#editor').html(marked(value));
  });
});