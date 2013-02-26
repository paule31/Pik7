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
  all: {
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
  all: {
    options: {
      baseUrl: 'src/script',
      paths: {
        almond: 'lib/vendor/almond/almond',
        jquery: 'lib/vendor/jquery/jquery',
        prefixfree: 'lib/vendor/prefix-free/prefixfree'
      },
      name: 'pik7',
      out: 'core/pik7.js',
      optimize: 'uglify'
    }
  }
},

groc: {
  glob: [
    'src/script/*.coffee',
    'src/script/lib/*.coffee',
    'src/script/server/*.coffee',
    'src/script/ui/*.coffee'
  ],
  out: './src/docs'
},

clean: [
  'src/script/*.js',
  'src/script/server/*.js',
  'src/script/lib/*.js',
  'src/script/ui/*.js',
  'src/script/test/*.js',
  'src/script/docs/*'
],

compress: {
  zip: {
    options: {
      archive: 'pik7-<%= pkg.version %>.zip'
    },
    files: [
      { src: 'index.html' },
      { src: 'presenter.html' },
      { src: 'readme.md' },
      { src: 'screenshot.png' },
      { src: 'server.js' },
      { src: 'core/**' },
      { src: 'themes/**' },
      { src: 'extras/**' },
      { src: 'presentations/Pik/**' },
      { src: 'presentations/Template/**' }
    ]
  }
},

parallel: {
  compile: [
    { grunt: true, args: ['coffee'], opts: { stdio: 'inherit' } },
    { grunt: true, args: ['stylus'], opts: { stdio: 'inherit' } }
  ],
  testAndOptimize: [
    { grunt: true, args: ['connect', 'qunit'], opts: { stdio: 'inherit' } },
    { grunt: true, args: ['requirejs'], opts: { stdio: 'inherit' } }
  ]
}

});


grunt.loadTasks('src/tasks');
grunt.loadNpmTasks('grunt-contrib');
grunt.loadNpmTasks('grunt-parallel');


grunt.registerTask('compile', ['parallel:compile', 'copy']);
grunt.registerTask('test',    ['connect', 'qunit']);
grunt.registerTask('finish',  ['clean', 'groc', 'compress']);


grunt.registerTask('dev-front', ['compile']);
grunt.registerTask('dev',       ['compile', 'parallel:testAndOptimize']);
grunt.registerTask('default',   ['compile', 'parallel:testAndOptimize', 'finish']);


};