$(document).ready(function(){
  module("Menu tests");

  test("Navigation test", function() {
    $('#menu').children('a').first().click();

    equal($('#menu').children('a').first().html(), "Back");

    $('#menu').children('a').first().click();

    $('#menu').children('a').first().click();

    equal($('#menu').children('a').last().html(), nestedMenu["study"]["contents"]["notes"]);
  });
});
