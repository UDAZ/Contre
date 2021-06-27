jQuery(function () {
  jQuery('.js-modal-close-repo').on('click', function () {
    jQuery('.js-modal-repo').fadeOut();
    return false;
  });
});
function onPopupOpenRepo() {
  jQuery(function () {
    jQuery('.js-modal-repo').fadeIn();
    return false;
  });
}
jQuery(function () {
  jQuery('#repo').on('click', function () {
    onPopupOpenRepo();
  });
});
