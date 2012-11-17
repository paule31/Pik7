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
      'themes/default.css': ['src/style/themes/default.styl'],
      'themes/template.css': ['src/style/themes/template.styl']
    }
  }
},

cslint: {
  app: {
    files: ['src/script/**/*.coffee'],
    options: {
      onErrors: 'fail',
      config: {
        max_line_length: {
          level : 'ignore'
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
      'ui/*.coffee',
      'lib/*.coffee'
    ]
  }
},

requirejs: {
  compile: {
    options: {
      baseUrl: 'src/script',
      paths: {
        jquery: 'lib/vendor/jquery-1.8.3.min',
        prefixfree: 'lib/vendor/prefixfree.min'
      },
      name: 'pik7',
      out: 'core/pik7.js',
      optimize: (grunt.cli.tasks.indexOf('dev') !== -1) ? 'none' : 'uglify'
    }
  }
},

clean: ['src/script/*.js', 'src/script/lib/*.js', 'src/script/ui/*.js', 'src/script/test/*.js'],

compress: {
  zip: {
    files: {
      'download.zip': [
        'index.html',
        'presenter.html',
        'readme.md',
        'core/pik7.js',
        'core/pik7.css',
        'core/welcome.html',
        'core/icons/icons.eot',
        'core/icons/icons.svg',
        'core/icons/icons.ttf',
        'core/icons/icons.woff',
        'core/icons/LICENSE.txt',
        'core/icons/README.txt',
        'themes/default.css',
        'themes/template.css',
        'presentations/Pik/**/*',
        'presentations/Template/**/*'
      ]
    }
  }
}

});

grunt.loadTasks('src/tasks');
grunt.loadNpmTasks('grunt-contrib');

grunt.registerTask('dev',     'stylus cslint coffee docco server qunit requirejs');
grunt.registerTask('default', 'stylus cslint coffee docco server qunit requirejs clean compress');

};