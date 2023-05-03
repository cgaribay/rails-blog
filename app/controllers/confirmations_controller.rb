class ConfirmationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email].downcase)

    if @user.present? && @user.unconfirmed?
      redirect_to root_path, notice: "Check your email for confirmation instructions"
    else
      redirect_to new_confirmation_path, alert: "We could not find a user with that email or the email has already been confirmed"
    end
  end

  def edit
    @user = User.find_signed(params[:confirmation_token], purpose: :confirm_email)

    if @user.present?
      redirect_to root_path, notice: "Your account has been confirmed"
    else
      redirect_to new_confirmation_path, alert: "Invalid token"
    end
  end
end
