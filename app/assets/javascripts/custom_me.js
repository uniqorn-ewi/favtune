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

    //子の要素を変数に入れる
    var $children = $('.children');
    //後のイベントで、不要なoption要素を削除するため、子の元の内容をとっておく
    var originChildren = $children.html();
    //親のselect要素が変更になるとイベントが発生
    $('.parent').change(function() {
      //選択された親のvalueを取得し変数に入れる
      var val1 = $(this).val();
      //削除された要素をもとに戻すため.子の元の内容を入れておく
      $children.html(originChildren).find('option').each(function() {
        //data-valの値を取得
        var val2 = $(this).data('val');
        //valueと異なるdata-valを持つ要素を削除
        if (val1 != val2) {
          $(this).not(':first-child').remove();
        }
      });
      //親のselect要素が未選択の場合、子をdisabledにする
      if ($(this).val() == "") {
        $children.attr('disabled', 'disabled');
      } else {
        $children.removeAttr('disabled');
      }
    });

    //孫の要素を変数に入れる
    var $grandchilds = $('.grandchilds');
    //後のイベントで、不要なoption要素を削除するため、孫の元の内容をとっておく
    var originGrandchilds = $grandchilds.html();
    //子のselect要素が変更になるとイベントが発生
    $('.children').change(function() {
      //選択された子のvalueを取得し変数に入れる
      var val1 = $(this).val();
      //削除された要素をもとに戻すため.孫の元の内容を入れておく
      $grandchilds.html(originGrandchilds).find('option').each(function() {
        //data-valの値を取得
        var val2 = $(this).data('val');
        //valueと異なるdata-valを持つ要素を削除
        if (val1 != val2) {
          $(this).not(':first-child').remove();
        }
      });
      //子のselect要素が未選択の場合、孫をdisabledにする
      if ($(this).val() == "") {
        $grandchilds.attr('disabled', 'disabled');
      } else {
        $grandchilds.removeAttr('disabled');
      }
    });

  }
});
