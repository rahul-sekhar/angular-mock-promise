module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-banner');
  grunt.loadNpmTasks('grunt-json-replace');

  grunt.initConfig
    version: grunt.file.read('version.txt')

    pkg: grunt.file.readJSON('bower.json')

    "json-replace":
      options:
        replace:
          version: '<%= version %>'
      default:
        files: [
          { src: 'package.json', dest: 'package.json' },
          { src: 'bower.json', dest: 'bower.json' }
        ]

    coffee:
      compile:
        files: {
          'dist/angular-mock-promise.js': 'src/*.coffee',
        }

    usebanner:
      options:
        banner: '/* <%= pkg.name %> <%= version %> %> */\n'
      files:
        src: ['dist/angular-mock-promise.js']


  grunt.registerTask('default', ['json-replace', 'coffee', 'usebanner']);
