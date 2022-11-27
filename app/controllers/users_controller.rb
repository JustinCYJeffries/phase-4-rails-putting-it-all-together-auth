class UsersController < ApplicationController
    def create
        user = User.create!(create_user_params)
        session[:user_id] ||= user.id
        render json: user, status: :created
    rescue ActiveRecord::RecordInvalid => invalid
        render json: { errors: [invalid.record.errors] }, status: :unprocessable_entity
    end

    def show
        user_id = session[:user_id]
        if user_id
            user = User.find(user_id)
            render json: user, status: :created
        else
            render json: { error: "Unauthorized" }, status: :unauthorized
        end
    end

    private

    def create_user_params
        params.permit(:username, :password_confirmation, :password, :image_url, :bio)
    end
end
