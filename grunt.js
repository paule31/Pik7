module.exports = function(grunt){

grunt.initConfig({

stylus: {
  compile: {
    options: {
      compress: true,
      paths: [
        require('nib').path
      ]
    },
    files: {
      'core/pik7.css': ['src/style/pik7.styl']
    }
  }
},

coffeescript: {
  src: {
    files: [
      'src/**/*.coffee'
    ],
    options: {
      bare: true
    }
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

requirejs: {
  compile: {
    options: {
      baseUrl: 'src/script',
      paths: {
        'jquery': 'lib/vendor/jquery-1.7.2.min',
        'prefixfree': 'lib/vendor/prefixfree.min'
      },
      name: 'pik7',
      out: 'core/pik7.js',
      optimize: 'none'
    }
  }
},

cleanupjs: {
  src: '<config:coffeescript.src.files>'
}

});

grunt.loadTasks('src/build/tasks');
grunt.loadNpmTasks('grunt-contrib');

grunt.registerTask('default',      'stylus coffeescript server qunit requirejs cleanupjs');


};