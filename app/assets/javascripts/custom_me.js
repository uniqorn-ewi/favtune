$(function() {
  'use strict'; // Start of use strict

  // Smooth scrolling using jQuery easing
  $('a.js-scroll-trigger[href*="#"]:not([href="#"])').click(function() {
    if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '')
    && location.hostname == this.hostname) {
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
      if (target.length) {
        $('html, body').animate({
          scrollTop: (target.offset().top - 0)
          //scrollTop: (target.offset().top - 54)
        }, 1000, 'easeInOutExpo');
        return false;
      }
    }
  });

  // Closes responsive menu when a scroll trigger link is clicked
  $('.js-scroll-trigger').click(function() {
    $('.navbar-collapse').collapse('hide');
  });

  // Activate scrollspy to add active class to navbar items on scroll
  $('body').scrollspy({
    target: '#mainNav',
    offset: 62
    //offset: 56
  });

//  //fixed navbar
//  var toggleAffix = function(affixElement, scrollElement, wrapper) {
//    var height = affixElement.outerHeight(), top = wrapper.offset().top;
//    if (scrollElement.scrollTop() >= top){
//        wrapper.height(height);
//        affixElement.addClass('affix');
//    }
//    else {
//        affixElement.removeClass('affix');
//        wrapper.height('auto');
//    }
//  };
//  $('[data-toggle="affix"]').each(function() {
//    var ele = $(this), wrapper = $('<div></div>');
//    ele.before(wrapper);
//    $(window).on('scroll resize', function() {
//      toggleAffix(ele, $(this), wrapper);
//    });
//    toggleAffix(ele, $(window), wrapper); // init
//  });

//  // Collapse Navbar
//  var navbarCollapse = function() {
//    if ($('#mainNav').offset().top > 100) {
//      $('#mainNav').addClass('navbar-shrink');
//    } else {
//      $('#mainNav').removeClass('navbar-shrink');
//    }
//  };
//  // Collapse now if page is not at top
//  // navbarCollapse(); //
//  // Collapse the navbar when page is scrolled
//  $(window).scroll(navbarCollapse);

    $(window).on('load', function() {
      $("#effect").prepend( '<div id="preloader"></div>');
      $("#preloader").fadeOut(2000);
      //$('#preloader').remove();
    });

    $(window).scroll(function() {
      if ($(this).scrollTop() < 50) {
        // hide nav
        $('nav').removeClass('vesco-top-nav');
        $('#back-to-top').fadeOut();
      } else {
        // show nav
        $('nav').addClass('vesco-top-nav');
        $('#back-to-top').fadeIn();
      }
    });

//    $('#back-to-top').click(function() {
//      $('html, body').animate({
//        scrollTop: 0
//      }, 'slow');
//      return false;
//    });

    $('#back-to-top').click(function() {
      $('html, body').animate({
        scrollTop: 0
      }, 1000, 'easeInOutExpo');
      return false;
    });
});
