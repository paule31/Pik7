module.exports = function(grunt) {

	// Groc task to generate documentation.
	grunt.registerTask('groc', 'groc processor.', function() {

		var groc = require('groc');
		var done = this.async();
		var opts = grunt.config.get('groc');
		var clis = [];

		// Convert `opts` object to a CLI list of arguments.
		for ( var key in opts ) {
			var flag = '--' + key;
			var value = opts[key];
			// If value is an array push each value
			if( Object.prototype.toString.call( value ) === '[object Array]' ) {
				for ( var i = 0, len = value.length; i < len; i++ ) {
					clis.push(flag);
					clis.push(value[i]);
				}
			}
			else {
				clis.push(flag);
				clis.push(value);
			}
		}

		// Run Groc's CLI command.
		groc.CLI(clis, function(error) {
			if (error) {
				grunt.warn(error);
				process.exit(1);
				done(false);
				return;
			}
			done();
		});

	});

};