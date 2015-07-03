var gulp = require("gulp");
var coffee = require("gulp-coffee");

gulp.task("default", ["coffee"], function () {
	// empty so that other functions can do the work
});

gulp.task("coffee", function() {
	return gulp.src("source/*.coffee")
		.pipe(coffee())
		.pipe(gulp.dest("compiled"));
});

gulp.task("watch", ["default"], function() {
    gulp.watch("source/*.coffee", ["coffee"]);
});