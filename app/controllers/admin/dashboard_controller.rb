# app/controllers/admin/dashboard_controller.rb
class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_user, only: [:edit, :update, :show]

  def index
    @users = User.all
  end

  def show
    @user = current_user
    @users = User.all
    @pending_users = User.pending
    symbol = params[:symbol]
    api_key = 'pk_3dbda283b9094177a492240a433bafa8'
    iex_service = IexService.new(api_key)
    
    # Fetch stock data for the specified symbol (if any)
    @stock_data = iex_service.stock_quote(symbol)
    
    # Fetch data for the top 10 stock symbols
    top_stock_symbols = ['AAPL', 'GOOGL', 'MSFT', 'AMZN', 'TSLA', 'FB', 'NVDA', 'PYPL', 'NFLX', 'INTC']
    @top_stocks_data = top_stock_symbols.first(10).map do |top_symbol|
      iex_service.stock_quote(top_symbol)
    end
  end
  

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_dashboard_index_path, notice: 'User created successfully.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_dashboard_path, notice: "User successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_dashboard_index_path, notice: 'User deleted successfully.'
  end

  def approve_user
    def approve_user
      @user = User.find(params[:id])
      @user.update(status: :approved)
  
      # Send account approval email
      UserMailer.account_approved(@user).deliver_now
  
      redirect_to admin_dashboard_index_path, notice: 'User approved successfully.'
    end
  end

  def reject_user
    @user = User.find(params[:id])
    @user.update(status: :pending)
    redirect_to admin_dashboard_index_path, notice: 'User set as pending.'
  end

  private

  def authenticate_admin!
    redirect_to root_path, alert: 'Access denied.' unless current_user&.admin?
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :admin)
  end
end
