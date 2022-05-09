class UsersController < ApplicationController

    def new
        render :new
    end
    
    def create
        user = User.new(user_params)
        if user.save
            render json: user
        else
            render json: @user.errors.full_message, status: unprocessable_entity
        end
    end

    private

    def user_params
        params.require(:users).permit(:username, :password_digest, :session_token)
    end
end
