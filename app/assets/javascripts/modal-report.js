jQuery(function () {
  jQuery('.js-modal-close').on('click', function () {
    jQuery('.js-modal').fadeOut();
    return false;
  });
});
function onPopupOpen() {
  jQuery(function () {
    jQuery('.js-modal').fadeIn();
    return false;
  });
}
jQuery(function () {
  jQuery('#repo').on('click', function () {
    onPopupOpen();
  });
});
