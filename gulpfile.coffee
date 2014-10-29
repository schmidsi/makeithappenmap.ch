browserSync = require 'browser-sync'
coffee      = require 'gulp-coffee'
ecstatic    = require 'ecstatic'
gulp        = require 'gulp'
gutil       = require 'gulp-util'
http        = require 'http'
notify      = require 'gulp-notify'
plumber     = require 'gulp-plumber'
jade        = require 'gulp-jade'
stylus      = require 'gulp-stylus'


paths =
    jade:   './src/*.jade'
    coffee: './src/script/*.coffee'
    stylus: './src/style/*.styl'



gulp.task 'brower-sync', ['coffee', 'jade'], ->
    browserSync.init
        proxy    : 'http://localhost:3000'
        port     : 8000
        browser  : 'google chrome canary'
        ghostMode:
            clicks   : true
            location : true
            forms    : true
            scroll   : false


gulp.task 'browser-reload', ['coffee', 'jade'], ->
    browserSync.reload()


gulp.task 'jade', ->
    return gulp.src(paths.jade)
        .pipe jade({pretty: true})
        .on 'error', notify.onError("Jade Error: <%= error.message %>")
        .pipe gulp.dest './'


gulp.task 'coffee', ->
    return gulp.src(paths.coffee)
        .pipe(coffee(bare=true))
        .pipe(gulp.dest('./build/js/'))


gulp.task 'stylus', ->
    return gulp.src(paths.stylus)
        .pipe plumber()
        .pipe stylus()
            # use: [nib(), rupture(), axis()]
        .on 'error', notify.onError("Stylus Error: <%= error.message %>")
        .pipe gulp.dest('./build/css/')
        .pipe browserSync.reload(stream: true)


gulp.task 'default', ['jade', 'coffee', 'stylus', 'brower-sync'], ->
    http.createServer( ecstatic( root: __dirname ) ).listen(3000)

    gutil.log gutil.colors.blue('Server listening on port 3000')

    gulp.watch paths.jade, ['jade', 'browser-reload']
    gulp.watch paths.coffee, ['coffee', 'browser-reload']
    gulp.watch paths.stylus, ['stylus']

    stdin = process.stdin
    # stdin.setRawMode true
    stdin.resume()
    stdin.setEncoding 'utf8'

    stdin.on 'data', (data) ->
        if data is '\u0003'
            process.exit()

        if 'br' is data.trim()
            browserSync.reload stream: false
            gutil.log('Reload all browsers')