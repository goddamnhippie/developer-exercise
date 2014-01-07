$(document).ready(function(){
  module("Accordion tests");

  test("Usage test", function() {
    ok($('.accordion-header > div').first().is(':visible'));

    var last_link = $('.accordion-header > a').last();

    last_link.click();

    ok(last_link.next('div').is(':visible'));
  });
});
