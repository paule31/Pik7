
define(function() {
  return function(app) {
    app.on('load', function() {
      var presentationTitle;
      presentationTitle = $('iframe')[0].contentWindow.$('title').text();
      return $('title').text(presentationTitle);
    });
    $('.reloadLink').click(function() {
      return $('iframe')[0].contentWindow.location.reload(true);
    });
    return $('.printLink').click(function() {
      var printPath;
      printPath = $('iframe')[0].contentWindow.location.href + '#print';
      return window.open(printPath);
    });
  };
});
