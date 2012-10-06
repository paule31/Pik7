
define(function() {
  return function(app) {
    return app.on('load', function() {
      var presentationTitle;
      presentationTitle = $('iframe')[0].contentWindow.$('title').text();
      return $('title').text(presentationTitle);
    });
  };
});
