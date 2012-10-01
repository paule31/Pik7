module.exports = function(grunt){

"use strict";

grunt.initConfig({

stylus: {
  compile: {
    options: {
      compress: (grunt.cli.tasks.indexOf('dev') !== -1) ? false : true,
      paths: [
        require('nib').path
      ]
    },
    files: {
      'core/pik7.css': ['src/style/pik7.styl'],
      'themes/default.css': ['src/style/themes/default.styl']
    }
  }
},

cslint: {
  app: {
    files: ['src/script/**/*.coffee'],
    options: {
      onErrors: 'warn',
      config: {
        max_line_length: {
          value: 90,
          level : 'error'
        }
      }
    }
  }
},

coffee: {
  compile: {
    options: {
      bare: true
    },
    files: (function(){
      var files = {};
      var path = 'src/**/*.coffee';
      var sources = grunt.file.expandFiles(path);
      sources.forEach(function(source){
        var destination = source.substring(0, source.length - 6) + 'js';
        files[destination] = source;
      });
      return files;
    })()
  }
},

server: {
  port: 1337,
  base: '.'
},

qunit: {
  all: (function(){
    var files = grunt.file.expandFiles('src/script/test/*.html');
    return files.map(function(file){
      return 'http://localhost:1337/' + file;
    });
  })()
},

docco: {
  src: {
    dest: 'src/script',
    files: [
      '*.coffee',
      'lib/*.coffee'
    ]
  }
},

requirejs: {
  compile: {
    options: {
      baseUrl: 'src/script',
      paths: {
        jquery: 'lib/vendor/jquery-1.8.2.min',
        prefixfree: 'lib/vendor/prefixfree.min'
      },
      name: 'pik7',
      out: 'core/pik7.js',
      optimize: (grunt.cli.tasks.indexOf('dev') !== -1) ? 'none' : 'uglify'
    }
  }
},

clean: ['src/script/*.js', 'src/script/lib/*.js', 'src/script/test/*.js']

});

grunt.loadTasks('src/tasks');
grunt.loadNpmTasks('grunt-contrib');

grunt.registerTask('dev',     'stylus cslint coffee docco server qunit requirejs');
grunt.registerTask('default', 'stylus cslint coffee docco server qunit requirejs clean');

};