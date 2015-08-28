var gulp = require("gulp");
var coffee = require("gulp-coffee");

gulp.task("default", ["coffee", "json"]);

gulp.task("coffee", function () {
  gulp.src("source/*.coffee")
    .pipe(coffee())
    .pipe(gulp.dest("compiled"));
});

gulp.task("json", function() {
  gulp.src("source/**/*.json")
    .pipe(gulp.dest("compiled"))
})

gulp.task("watch", ["default"], function() {
  gulp.watch("source/*.coffee", ["coffee"]);
  gulp.watch("source/*.json", ["json"]);
});
