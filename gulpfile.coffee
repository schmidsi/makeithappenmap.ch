coffee   = require 'gulp-coffee'
ecstatic = require 'ecstatic'
gulp     = require 'gulp'
gutil    = require 'gulp-util'
http     = require 'http'
jade     = require 'gulp-jade'


gulp.task 'jade', ->
    return gulp.src './src/*.jade'
        .pipe jade({pretty: true})
        .pipe gulp.dest './'

gulp.task 'coffee', ->
    return gulp.src('./src/script/*.coffee')
        .pipe(coffee(bare=true))
        .pipe(gulp.dest('./build/js/'))


gulp.task 'default', ['jade', 'coffee'], ->
    http.createServer( ecstatic( root: __dirname ) ).listen(8000)

    gutil.log gutil.colors.blue('Server listening on port 8000')
    gulp.watch './src/*.jade', ['jade']
    gulp.watch './src/script/*.coffee', ['coffee']