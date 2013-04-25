var require = {
  baseUrl: '',
  paths: {
    almond: 'lib/vendor/almond/almond',
    jquery: 'lib/vendor/jquery/jquery',
    prefixfree: 'lib/vendor/prefixfree.min'
  }
};

var runTestsFor = function(file, baseUrl){
  require.baseUrl = baseUrl;
  require.paths[file] = 'test/' + file;
  document.write('<script src="../lib/vendor/qunit/qunit.js"></script>');
  document.write('<link rel="stylesheet" href="../lib/vendor/qunit/qunit.css">');
  document.write('<script src="../lib/vendor/requirejs/require.js" data-main="' + file + '"></script>');
};