$(document).on('turbolinks:load', function(){
  App.cable.subscriptions.create('AnswersChannel', {
    connected() {
      let questionId = document.querySelector("div.question").getAttribute("data-id");
      this.perform('follow', {question_id: questionId});
    },
    received(data) {
      let parsedData = JSON.parse(data);
      data.user = parsedData.user;
      data.rating = parsedData.rating;
      parsedData.vote_up_path = '/answers/' + parsedData.id + '/vote_up';
      parsedData.vote_down_path = '/answers/' + parsedData.id + '/vote_down';

      let renderedData = JST['templates/answer'](parsedData);
      $('.answers').append(renderedData);

      $('.vote').off('click').on('click', function() {
        var id = $(this).data('id');
        var action = $(this).hasClass('plus') ? 'vote_up' : 'vote_down';
        var path = (action === 'vote_up') ? parsedData.vote_up_path : parsedData.vote_down_path;

        $.ajax({
            url: path,
            type: 'PATCH',
            success: function(response) {
              $('#answer-' + id + ' .score').text(response.resourceScore);
            }
          });

          return false;
        });
    }
  });
});
