$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })
  $('form.new-answer').on('ajax:success', function(e) {
    var answer = e.detail[0];
    //console.log(answer)

    var answerHtml = '<p>' + answer.body + '</p>';

    var gistRegex = /^https:\/\/gist\.github\.com\/\w+\/\w+/i;

    if (answer.links) {
      answer.links.forEach(function(link) {
        if (gistRegex.test(link.url)) {
          var gistParts = link.url.split('/');
          var gistId = gistParts[gistParts.length - 1];
          answerHtml +=`<div class="gist" data-gist-id="${gistId}"></div>`;
        } else {
          answerHtml += '<a href="' + link.url + '">' + link.name + '</a><br>';
        }
      });
    }

    if(answer.files_info) {
      answer.files_info.forEach(function(file) {
        answerHtml += '<a href="' + file.url + '">' + file.name + '</a><br>';
      });
    }

    $('.answers').append(answerHtml);
    $('.answers').find('.gist').each(function(){
      window.GistEmbed.init($(this));
    });
    $('.new-answer #answer_body').val('');
    $('.new-answer input[id^="answer_links_attributes_"][id$="_name"]').val('');
    $('.new-answer input[id^="answer_links_attributes_"][id$="_url"]').val('');
    $('.nested-fields:not(:first)').remove();
    $('.answer-errors').empty();
  })
    .on('ajax:error', function (e) {
      var errors = e.detail[0];
      $('.answer-errors').empty();
      $.each(errors, function(index, value) {
        $('.answer-errors').append('<p>' + value + '</p>');
      })
    });
});
