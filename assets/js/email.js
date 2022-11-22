$(function() {
  $("a.email").attr("href", function (i, val) {
    return val.replace(/ AT /g, "@").replace(/ DOT /g, ".");
  });
  $("a.email").html(function (i, val) {
    return val.replace(/ AT /g, "@").replace(/ DOT /g, ".");
  });
});
