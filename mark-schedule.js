function addClassesToSchedule() {
  $.fn.reverse = [].reverse;

  var now = new Date();
  var year = 2014; // now.getYear() + 1900;
  var lastDay = undefined;
  var lastRow = undefined;

  $("#schedule-table > tr").reverse().each(function (i, row) {
    if ($(row).children().size() > 1) {
      var th = $(row).children("th");

      if (th) {
        var dateText = th.html();
        var date = new Date(dateText + " " + year);

        if (date && date.getTime()) {
          // highlight the current or next lecture
          if (now.getTime() < date.getTime()+86400000) {
            if (lastRow) {
              $(lastRow).removeClass("today");
            }
            $(row).addClass("today");
          }

          lastRow = row;
        }
      }
    }
  });

  $("#schedule-table > tr").each(function (i, row) {
    if ($(row).children().size() > 1) {
      var th = $(row).children("th");

      if (th) {
        var dateText = th.html();
        var date = new Date(dateText + " " + year);

        if (date && date.getTime()) {
          if (lastDay == undefined || lastDay > date.getDay()) {
            $(row).addClass("week");
          }

          lastDay = date.getDay();
        }
      }
    }
  });
}
