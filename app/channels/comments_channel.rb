class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comments_channel_#{params[:question_id]}"
  end
end
