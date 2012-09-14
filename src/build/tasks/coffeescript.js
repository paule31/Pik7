module.exports = function(grunt){
  "use strict";

  grunt.registerMultiTask('coffeescript', 'Compile coffee files into JavaScript', function(){
    var files = grunt.file.expandFiles(this.data.files);
    var options = this.data.options;
    files.forEach(function(file){
      var javascript = grunt.helper('coffee-file', file, options);
      if(javascript !== null){
        var dest = file.split('.coffee')[0] + '.js';
        grunt.file.write(dest, javascript);
        grunt.log.ok('Compiled ' + file + ' into ' + dest);
      }
      else {
        grunt.log.error('Failed to compile ' + file);
      }
    });
    if(this.errorCount){
      return false;
    }
  });

  grunt.registerHelper('coffee-file', function(file, options){
    var coffee = require('coffee-script');
    var opts = grunt.utils._.extend({filename: file}, options);
    try {
      var source = grunt.file.read(file);
      return coffee.compile(source, opts);
    }
    catch (e){
      grunt.log.error(e);
      return null;
    }
  });

};