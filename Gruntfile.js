module.exports = function(grunt){

grunt.initConfig({

pkg: grunt.file.readJSON('package.json'),

stylus: {
  compile: {
    options: {
      compress: true,
      paths: [require('nib').path]
    },
    files: {
      'core/pik7.css': ['src/style/pik7.styl'],
      'themes/default.css': ['src/style/themes/default.styl'],
      'themes/template.css': ['src/style/themes/template.styl']
    }
  }
},

coffee: {
  compile: {
    options: {
      bare: true
    },
    files: [{
      expand: true,
      cwd: 'src/',
      src: ['**/*.coffee'],
      dest: 'src/',
      ext: '.js'
    }]
  }
},

copy: {
  all: {
    files: {
      'server.js': 'src/script/server/server.js'
    }
  }
},

connect: {
  server: {
    options: {
      port: 1337
    }
  }
},

qunit: {
  all: {
    options: {
      urls: (function(){
        var files = grunt.file.expand('src/script/test/*.html');
        return files.map(function(file){
          return 'http://localhost:1337/' + file;
        });
      })()
    }
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
      optimize: 'uglify'
    }
  }
},

clean: [
  'src/script/*.js',
  'src/script/server/*.js',
  'src/script/lib/*.js',
  'src/script/ui/*.js',
  'src/script/test/*.js'
],

compress: {
  zip: {
    options: {
      archive: 'pik7-' + JSON.parse(require('fs').readFileSync('package.json')).version + '.zip'
    },
    files: [
      { src: 'index.html' },
      { src: 'presenter.html' },
      { src: 'readme.md' },
      { src: 'screenshot.png' },
      { src: 'server.js' },
      { src: 'core/**' },
      { src: 'themes/**' },
      { src: 'presentations/Pik/**' },
      { src: 'presentations/Template/**' }
    ]
  }
}

});


grunt.loadNpmTasks('grunt-contrib');


grunt.registerTask('compile',   ['stylus', 'coffee', 'copy']);
grunt.registerTask('test',      ['connect', 'qunit']);

grunt.registerTask('dev',       ['compile', 'test', 'requirejs']);
grunt.registerTask('default',   ['compile', 'test', 'requirejs', 'clean', 'compress']);


};