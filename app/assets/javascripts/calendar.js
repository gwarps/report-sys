$(document).ready(function() {
    $("#start_date").datepicker({ dateFormat: "yy/mm/dd" });
    $("#end_date").datepicker({ dateFormat: "yy/mm/dd" });

    $("#tabs").tabs();

    $('.date-picker').datepicker( {
        changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        altFormat: 'mm yy',

        onClose: function(dateText, inst) {
            var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
            var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
            $(this).val($.datepicker.formatDate('mm-yy', new Date(year, month, 1)));

        }

      });

      $(".date-picker").focus(function () {
        $(".ui-datepicker-calendar").hide();

      });

          


  });
