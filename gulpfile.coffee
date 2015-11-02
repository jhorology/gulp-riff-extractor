gulp        = require 'gulp'
coffeelint  = require 'gulp-coffeelint'
coffee      = require 'gulp-coffee'
del         = require 'del'
data        = require 'gulp-data'
watch       = require 'gulp-watch'
beautify    = require 'js-beautify'


$ =
  userContentDir: "#{process.env.HOME}/Documents/Native Instruments/User Content"
  
gulp.task 'coffeelint', ->
  gulp.src ['./*.coffee', './src/*.coffee']
    .pipe coffeelint './coffeelint.json'
    .pipe coffeelint.reporter()

gulp.task 'coffee', ['coffeelint'], ->
  gulp.src ['./src/*.coffee']
    .pipe coffee()
    .pipe gulp.dest './lib'

gulp.task 'default', ['coffee']

gulp.task 'watch', ->
  gulp.watch './**/*.coffee', ['default']
 
gulp.task 'clean', (cb) ->
  del ['./lib/*.js', './**/*~', './test_out'], force: true, cb

gulp.task 'test', [
  'default'
  '_test-default'
  '_test-buffer'
  '_test-padding'
  '_test-header'
  '_test-select'
  ]

gulp.task '_test-default', ['default'], ->
  extract = require './'
  gulp.src ["sample.riff"]
    .pipe extract
      form_type: 'NIKS'
    .pipe gulp.dest './test_out'

gulp.task 'test-multi', ['default'], ->
  extract = require './'
  gulp.src ["#{$.userContentDir}/Serum/**/*.nksf"]
    .pipe extract
      form_type: 'NIKS'
    .pipe gulp.dest './test_out'

gulp.task '_test-buffer', ['default'], ->
  extract = require './'
  gulp.src ["sample.riff"], read: on
    .pipe extract
      form_type: 'NIKS'
      filename_template: "<%= basename %>_buffer.<%= id.trim().toLowerCase() %>"
    .pipe gulp.dest './test_out'

gulp.task '_test-padding', ['default'], ->
  extract = require './'
  gulp.src ["sample.riff"]
    .pipe extract
      form_type: 'NIKS'
      padding: on
      filename_template: "<%= basename %>_padding.<%= id.trim().toLowerCase() %>"
    .pipe gulp.dest './test_out'

gulp.task '_test-header', ['default'], ->
  extract = require './'
  gulp.src ["sample.riff"]
    .pipe extract
      form_type: 'NIKS'
      header: on
      filename_template: "<%= basename %>_header.<%= id.trim().toLowerCase() %>"
    .pipe gulp.dest './test_out'

gulp.task '_test-select', ['default'], ->
  extract = require './'
  gulp.src ["sample.riff"]
    .pipe extract
      form_type: 'NIKS'
      chunk_ids: ['NISI', 'PLID']
      filename_template: "<%= basename %>_select.<%= id.trim().toLowerCase() %>"
    .pipe gulp.dest './test_out'
