class Api::V1::SessionsController < ApplicationController
  def sign_up
    @user = User.new(user_params)
    if @user.save
      render json: { user: @user, status: :accepted }
    else
      render json: {
        error: 'Unable to save entity',
        message: "#{@user.errors.full_messages.join(', ')} ",
        status: :bad_request
      }
    end
  end

  def login
    @user = User.find_by_username(login_params[:username])
    if @user&.authenticate(login_params[:password])
      # TODO: Implement JWT token
      render json: { user: @user, jwt: 'hello', status: :accepted }
    else
      render json: {
        error: 'Unable to authenticate',
        message: 'User or Password is wrong',
        status: :not_acceptable
      }
    end
  end
end

private

def login_params
  params.require(:user).permit(:username, :password)
end

def sign_up_params
  params.require(:user).permit(:username, :password, :email)
end