class PasswordsController < ApplicationController
  before_action :redirect_if_authenticated

  def new
  end

  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user.present?
      if @user.confirmed?
        @user.send_password_reset_email
        redirect_to root_path, notice: "Check your email for instructions to modify the password"
      else
        redirect_to new_confirmation_path, alert: "Please confirm your email"
      end
    else
      redirect_to root_path, notice: "Invalid email"
    end
  end

  def edit
    @user = User.find_signed(params[:password_reset_token], purpose: :reset_password)
    p "USER: #{@user.present?}  #{@user.unconfirmed?}"
    if @user.present? && @user.unconfirmed?
      redirect_to new_confirmation_path, alert: "Please confirm your email"
    elsif @user.nil?
      redirect_to new_password_path, alert: "Invalid or expired token"
    end
  end

  def update
    @user = User.find_signed(params[:password_reset_token], purpose: :reset_password)
    if @user
      if @user.unconfirmed?
        redirect_to new_confirmation_path, alert: "Please confirm your email"
      elsif @user.update(password_params)
        redirect_to login_path, notice: "Sign in."
      else
        flash.now[:alert] = @user.errors.full_messages.to_sentence
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Invalid or expired token"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
