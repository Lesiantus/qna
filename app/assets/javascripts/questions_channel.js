$(document).on('turbolinks:load', function (){
    App.cable.subscriptions.create('QuestionsChannel', {
        connected() {
            console.log('connected!');
            this.perform('follow');
        },

            received(data) {
                 $('.questions-index').append(`<a href="questions/${data.id}">${data.title}</a>`);

        },
    });
});
