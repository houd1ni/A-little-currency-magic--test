gulp = require 'gulp'
minifyHTML = require 'gulp-minify-html'
cjsx = require 'gulp-cjsx'
sources = require './sources.coffee'
sources = sources.map (a)-> a = 'src/'+a
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
minifyCSS = require 'gulp-minify-css'
stylus = require 'gulp-stylus'
sourcemaps = require 'gulp-sourcemaps'

gulp.task 'default', ['htmlpage', 'coffee'], ->
	log = (event)->
		console.log('Event type: ' + event.type);
		console.log('Event path: ' + event.path);
	
	watcherCOFFEE = gulp.watch(['./src/*.cjsx','./src/*.coffee'], ['coffee']);
	watcherCOFFEE.on('change', log);

	watcherSTYLUS = gulp.watch('./src/*.styl', ['styl']);
	watcherSTYLUS.on('change', log);


gulp.task 'coffee', ->
  gulp.src(sources)
		.pipe(concat('app.js'))
		.pipe(cjsx())
		.pipe(uglify())
    .pipe(gulp.dest('./public'));

gulp.task 'styl', ->
  gulp.src('./src/*.styl')
    .pipe(stylus())
		.pipe(concat('layout.css'))
		.pipe(minifyCSS())
    .pipe(gulp.dest('./public'));

gulp.task 'htmlpage', ->
	htmlSrc = './src/*.html'
	htmlDst = './public'
 
	gulp.src(htmlSrc)
		.pipe(minifyHTML())
		.pipe(gulp.dest(htmlDst));
		
gulp.task 'test', ->
	true