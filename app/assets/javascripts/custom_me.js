$(function() {
  $(window).on('load', function() {
    $("#effect").prepend( '<div id="preloader"></div>');
    $("#preloader").fadeOut(2000);
  });
});

$(window).scroll(function() {
  if ($(this).scrollTop() < 50) {
    $('#back-to-top').fadeOut();
  } else {
    $('#back-to-top').fadeIn();
  }
});

// ページ切り替え時（初回ページも対象）
$(document).on({
  'turbolinks:load': function() {
    $('#back-to-top').click(function() {
      $('html, body').animate({
        scrollTop: 0
      }, 1000, 'easeInOutExpo');
      return false;
    });
  }
});
