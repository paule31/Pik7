// Creates docs using [Docco](http://jashkenas.github.com/docco/)

module.exports = function(grunt){

  var cp = require('child_process');
  var path = require('path');

  grunt.registerMultiTask('docco', 'Create docco documentation', function(){
    var done = this.async();
    var destination = this.data.dest;
    var files = grunt.file.expandFiles(this.data.files.map(function(file){
      return path.resolve(path.join(destination, file));
    }));
    grunt.helper('docco-create', files, destination, function(exitCode){
      if(exitCode === 0){
        files.forEach(function(file){
          grunt.log.ok('Created docs for ' + file);
        });
      }
      else {
        grunt.log.error('Error: Docco exited with code ' + exitCode);
      }
      done();
    });
  });

  grunt.registerHelper('docco-create', function(files, destination, callback){
    var docco = cp.spawn('docco', files, {
      cwd: destination
    });
    docco.on('exit', callback);
  });

};