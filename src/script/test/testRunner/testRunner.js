var require = {
  baseUrl: '',
  paths: {
    jquery: 'lib/vendor/jquery-1.8.2.min',
    prefixfree: 'lib/vendor/prefixfree.min'
  }
};

var runTestsFor = function(file, baseUrl){
  var qunitVersion = '1.10.0';
  require.baseUrl = baseUrl;
  require.paths[file] = 'test/' + file;
  document.write('<script src="../lib/vendor/qunit/qunit-' + qunitVersion + '.js"></script>');
  document.write('<link rel="stylesheet" href="../lib/vendor/qunit/qunit-' + qunitVersion + '.css">');
  document.write('<script src="../../../core/require.js" data-main="' + file + '"></script>');
};