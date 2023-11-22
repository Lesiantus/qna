$(document).on('turbolinks:load', function (){
    App.cable.subscriptions.create({ channel: 'CommentsChannel', question_id: gon.question_id }, {
        connected() {
            this.perform('follow');
        },

        received(data) {
            let formElement = '';
            if (data.commentable_type == 'Answer') {
                formElement = `form[action="/answers/${data.commentable_id}/add_comment"]`;
                $(`.question[data-id="${gon.question_id}"] .answers .answer-${data.commentable_id} .answer-comments`).append(`<p>${data.body}`);
            } else if (data.commentable_type == 'Question') {
                formElement = `form[action="/questions/${data.commentable_id}/add_comment"]`;
                $(`.question[data-id="${data.commentable_id}"] .question-comments`).append(`<p>${data.body}`);
            }
            if (formElement) {
                $(formElement).find('textarea').val('');
            }
        }
    });
});
