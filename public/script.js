
var lastRequestedWord = "";


function bindEvents() {
  $("#search-input").keydown(function(e) {
    if (e.keyCode == 40) {
      var active = $(".active-suggestion");
      if (active.length == 0) {
        $("#suggestion-panel").children().first().addClass("active-suggestion");
      } else {
        var next = active.next();
        if (next.length == 0) return false;
        active.removeClass("active-suggestion");
        next.addClass("active-suggestion");
      }
      return false;
    } else if (e.keyCode == 38) {
      var active = $(".active-suggestion");
      if (active.length == 0) return false;
      var prev = active.prev();
      active.removeClass("active-suggestion");
      if (prev.length == 0) {
        return;
      };
      prev.addClass("active-suggestion");
      return false;
    }
  });

  $("#search-input").keyup(function() {
    var word = $("#search-input").val()
    getSuggestions(word);
  })

  $("#search-form").on("submit", function(){
    var active = $(".active-suggestion");
    var word;
    if (active.length > 0) {
      word = active.text();
      $("#search-input").val(word);
      $("#search-input").keyup();
    }
    word = $("#search-input").val();
    loadWord(word);
    return false;
  });

  $("#suggestion-panel").on("click", function(e){
    var word = $(e.target).text();
    $("#search-input").val(word);
    $("#search-input").keyup();
    $("#search-form").submit();
  });

  $("#suggestion-panel").on("mousemove", function(e){
    $(".active-suggestion").removeClass("active-suggestion");
    $(e.target).addClass("active-suggestion");
  });
}

function getSuggestions(word) {
  if (word == lastRequestedWord) {
    return;
  }
  lastRequestedWord = word;
  $.ajax({
   url: "/suggestions",
   data: {
    word: word
   },
   success: function(data) {
    $("#suggestion-panel").html("");
    data = JSON.parse(data);
    data.forEach(function (d) {
      $("#suggestion-panel").append("<div>" + d + "</div>")
    }, this);
    if (data.length > 0) {
      $("#suggestion-panel").show();
    } else {
      $("#suggestion-panel").hide();
    }
   }
   
});
}


$( document ).ready(function() {
    bindEvents();
    $("#search-input").focus();

});

