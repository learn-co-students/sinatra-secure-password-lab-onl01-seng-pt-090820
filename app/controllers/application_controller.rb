require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    user = User.new(username: params[:username], password: params[:password], balance: 0.0)
    
    if !user.username.empty? && user.save
      redirect '/login'
    else
      redirect '/failure'
    end
  end

  get '/account' do
    erb :account
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/account'
    else
      redirect '/failure'
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  get '/deposit' do
    erb :deposit
  end

  get '/withdraw' do
    erb :withdraw
  end

  post '/deposit' do
    deposit = params[:deposit]
    
    if deposit.to_f > 0.0
      current_user.update(balance: (current_user.balance + deposit.to_f))
      redirect '/account'
    else
      erb :deposit_error
    end
  end

  post '/withdraw' do
    withdraw = params[:withdraw]

    if withdraw.to_f.between?(0.0, current_user.balance)
      current_user.update(balance: (current_user.balance - withdraw.to_f))
      redirect '/account'
    else
      erb :withdraw_error
    end
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
