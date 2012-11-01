// http://www.coffeelint.org/

module.exports = function(grunt){
  'use strict';

  var coffeelint = require('coffeelint');

  grunt.registerMultiTask('cslint', 'Lint files with CoffeeLint', function(){

    var files = grunt.file.expandFiles(this.data.files);
    var options = this.data.options;
    var failures = [];

    files.forEach(function(file){
      var errors = coffeelint.lint(grunt.file.read(file), options.config);
      if(errors.length === 0){
        grunt.log.ok(file + ' lint free.');
      }
      else {
        errors.forEach(function(err){
          grunt.log.error(file + ':' + err.lineNumber + ' ' + err.message + ' (' + err.rule + ')');
          if(failures.indexOf(file) === -1){
            failures.push(file);
          }
        });
      }
    });

    if(failures.length > 0){
      var err = 'Lint in ' + failures.join(', ');
      if(options.onErrors === 'fail'){
        grunt.fail.warn(err);
      }
      else if(options.onErrors === 'warn'){
        grunt.log.error(err);
      }
    }

  });

};