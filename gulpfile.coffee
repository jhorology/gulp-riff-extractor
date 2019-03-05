gulp        = require 'gulp'
coffeelint  = require 'gulp-coffeelint'
coffee      = require 'gulp-coffee'
del         = require 'del'
data        = require 'gulp-data'
beautify    = require 'js-beautify'


$ =
  userContentDir: "#{process.env.HOME}/Documents/Native Instruments/User Content"
  
gulp.task 'coffeelint', ->
  gulp.src ['./*.coffee', './src/*.coffee']
    .pipe coffeelint './coffeelint.json'
    .pipe coffeelint.reporter()

_coffee = ->
  gulp.src ['./src/*.coffee']
    .pipe coffee()
    .pipe gulp.dest './lib'
    
gulp.task 'coffee', gulp.series 'coffeelint', _coffee

gulp.task 'default', gulp.series 'coffeelint', _coffee

gulp.task 'watch', ->
  gulp.watch './**/*.coffee', gulp.task 'coffee'
 
gulp.task 'clean', (cb) ->
  del ['./lib/*.js', './**/*~', './test_out'], force: true, cb


gulp.task '_test-default', ->
  extract = require './'
  gulp.src ["sample.riff"]
    .pipe extract
      form_type: 'NIKS'
    .pipe gulp.dest './test_out'

gulp.task 'test-multi', ->
  extract = require './'
  gulp.src ["#{$.userContentDir}/Serum/**/*.nksf"]
    .pipe extract
      form_type: 'NIKS'
    .pipe gulp.dest './test_out'

gulp.task '_test-buffer', ->
  extract = require './'
  gulp.src ["sample.riff"], read: on
    .pipe extract
      form_type: 'NIKS'
      filename_template: "<%= basename %>_buffer.<%= id.trim().toLowerCase() %>"
    .pipe gulp.dest './test_out'

gulp.task '_test-padding', ->
  extract = require './'
  gulp.src ["sample.riff"]
    .pipe extract
      form_type: 'NIKS'
      padding: on
      filename_template: "<%= basename %>_padding.<%= id.trim().toLowerCase() %>"
    .pipe gulp.dest './test_out'

gulp.task '_test-header', ->
  extract = require './'
  gulp.src ["sample.riff"]
    .pipe extract
      form_type: 'NIKS'
      header: on
      filename_template: "<%= basename %>_header.<%= id.trim().toLowerCase() %>"
    .pipe gulp.dest './test_out'

gulp.task '_test-select', ->
  extract = require './'
  gulp.src ["sample.riff"]
    .pipe extract
      form_type: 'NIKS'
      chunk_ids: ['NISI', 'PLID']
      filename_template: "<%= basename %>_select.<%= id.trim().toLowerCase() %>"
    .pipe gulp.dest './test_out'

gulp.task 'test', gulp.series 'coffee', gulp.parallel(
  '_test-default',
  '_test-buffer',
  '_test-padding',
  '_test-header',
  '_test-select',
)
