class MessagesController < ApplicationController
  before_action :require_user

  def index
    @messages = Message.all
    @message = Message.new
  end

  def create
    @message = current_user.messages.build(message_params)
    if @message.save
      ActionCable.server.broadcast "chat_channel", { message: render_message(@message) }
      respond_to do |format|
        format.js { }
      end
    end
  end

  private

  def require_user
    unless current_user
      flash[:alert] = "You must be logged in to access this page."
      redirect_to root_path
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def render_message(message)
    ApplicationController.render(
      partial: 'messages/message',
      locals: { message: message, current_user: current_user }
    )
  end
  
end