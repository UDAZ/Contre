jQuery(function () {
  jQuery('.js-modal-close-fav').on('click', function () {
    jQuery('.js-modal-fav').fadeOut();
    return false;
  });
});
function onPopupOpenFav() {
  jQuery(function () {
    jQuery('.js-modal-fav').fadeIn();
    return false;
  });
}
jQuery(function () {
  jQuery('.fav').on('click', function () {
    onPopupOpenFav();
  });
});
