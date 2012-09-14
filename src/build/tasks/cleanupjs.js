// Entfernt .js-Dateien, die beim kompilieren von .coffee-Dateien anfallen (natürlich
// _nachdem_ die .js-Dateien weiterverarbeitet worden sind)

module.exports = function(grunt){

  grunt.registerMultiTask('cleanupjs', 'Clean up generated .js files', function(){
    var fs = require('fs');
    var files = grunt.file.expandFiles(this.data);
    files.forEach(function(file){
      var path = file.split('.coffee')[0] + '.js';
      fs.unlinkSync(path);
      grunt.log.ok('Cleaned up ' + path);
    });

  });

};