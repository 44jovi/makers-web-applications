require 'sinatra/base'
require "sinatra/reloader"

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
  end

  post '/hello' do
    @name = params[:name]

    if params_invalid?
      status 400
      return "Invalid input!"
    end

    return erb(:hello)
  end
end


  def params_invalid?
    params[:name] =~ /\W/
  end
