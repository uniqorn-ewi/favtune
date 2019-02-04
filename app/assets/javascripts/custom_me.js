function setMsg(ajaxMsg) {
  $("#ajax-msg").replaceWith(
    '<div id="ajax-msg">' + ajaxMsg +'</div>');
}

var wikipediaHTMLResult = function(data) {
  var ref = data.parse.text["*"].replace(/<br \/>/g,  ', ')
  var readData = $('<div>' + ref + '</div>');

  // handle redirects
  var redirect = readData.find('li:contains("REDIRECT") a').text();
  if(redirect != '') {
    callWikipediaAPI(redirect);
    return;
  }

  var callsign = $("#callsign").val();
  var city = '', branding = '';
  var format = '', webcast = '', website = '';

  var reFormatOK = /(Oldies|Classic rock|Classic hits)/i;
  var reErrURL1 = /^http(s)?:\/\/www.iheart.com/;
  var reErrURL2 = /^http(s)?:\/\/player.radio.com/;
  var reURL1 = /(\.pls|\.m3u|\.asx)/;
  var reURL2 = /^http(s)?:\/\/([\w-]+\.)+[\w-]+(:[0-9]+)+(\/)?$/;

  var ajaxMsg = '';

  //項目の取得
  var box = readData.find('.infobox');
  var elements = box.find('tr');
  //項目の設定
  elements.each(function() {
    if($(this).find('th').text() == 'City') {
      city = $(this).find('td').text();
    }
    else if($(this).find('th').text() == 'Branding') {
      branding = $(this).find('td').text();
    }
    else if($(this).find('th').text() == 'Format') {
      format = $(this).find('td').text();
    }
    else if($(this).find('th').text() == 'Webcast') {
      webcast = $(this).find('td').find('a').first().attr('href');
    }
    else if($(this).find('th').text() == 'Website') {
      website = $(this).find('td').find('a').first().attr('href');
    }
  });

  if(!reFormatOK.test(format)) {
    ajaxMsg = 'Format NG!';
    setMsg(ajaxMsg);
  }
  else if (webcast == '') {
    ajaxMsg = 'Webcast None!';
    setMsg(ajaxMsg);
  }
  else if (reErrURL1.test(webcast) || reErrURL2.test(webcast)) {
    ajaxMsg = 'Webcast were discontinued outside the United States!';
    setMsg(ajaxMsg);
  }
  else {
    //項目の設定
    $("#city").val(city);
    $("#branding").val(branding);
    $("#station_format").val(format);
    $("#website").val(website);

    if (reURL1.test(webcast) || reURL2.test(webcast)) {
      ajaxMsg = 'Input Webcast';
      setMsg(ajaxMsg);
      //画面のリンクを変更
      var search = '<div id="station-search">' +
        '<a rel="noopener" target="_blank" ' +
        'href="https://tunein.com/search/?query=' + callsign +
        '">' + callsign + ' - Tunein Search</a></div>'
      $("#station-search").replaceWith(search);
      //項目の設定
      $("#comment").val(
        'Stream URL for App like iTunes\n' + webcast);
    }
    else {
      //項目の設定
      $("#webcast_url").val(webcast);
    }

  }
};

function callWikipediaAPI(wikipediaPage) {
  $.getJSON(
    'https://en.wikipedia.org/w/api.php?action=parse&format=json&callback=?',
    {page:wikipediaPage, prop:'text|images', uselang:'en'},
    wikipediaHTMLResult);
}

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
    //後のイベントで、不要なoption要素を削除するため、元の内容をとっておく
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
    //後のイベントで、不要なoption要素を削除するため、元の内容をとっておく
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

    //孫のselect要素が変更になるとイベントが発生
    $('.grandchilds').change(function() {
      //選択された孫のvalueを取得し変数に入れる
      var cs = $(this).val();
      //画面のリンクを変更
      var wiki = '<div id="station-wiki">' +
        '<a rel="noopener" target="_blank" ' +
        'href="https://en.wikipedia.org/wiki/' + cs +
        '">' + cs + ' - Wikipedia</a></div>'
      $("#station-wiki").replaceWith(wiki);
      //初期化
      $("#station-search").replaceWith('<div id="station-search"></div>');
      $("#ajax-msg").replaceWith('<div id="ajax-msg"></div>');
      $("#city").val('');
      $("#branding").val('');
      $("#station_format").val('');
      $("#webcast_url").val('');
      $("#website").val('');
      $("#comment").val('');
      //項目の設定
      $("#callsign").val(cs);
      //関数呼び出し
      callWikipediaAPI(cs);
    });

  }
});
