class ChatChannel < ApplicationCable::Channel
    def subscribed
      stream_from "chat_channel"
    end
  
    def receive(data)
      user = User.find_by(id: data['user_id'])
      message = user.messages.build(content: data['message'])
      if message.save
        ActionCable.server.broadcast "chat_channel", { message: render_message(@message) }
      end
    end
  
    private
  
    def render_message(message)
      ApplicationController.render(
        partial: 'messages/message',
        locals: { message: message }
      )
    end
  end