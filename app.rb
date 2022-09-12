# file: app.rb
require 'sinatra/base'
require 'sinatra/reloader'

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  post '/' do
    # This route is not executed (the method doesn't match).
  end

  get '/hello' do
    # This route is not executed (the path doesn't match).    
  end

  get '/' do
    # This route matches! The code inside the block will be executed now.
  end

  get '/' do
    # This route matches too, but will not be executed.
    # Only the first one matching (above) is.
  end
end



# # original

# class Application < Sinatra::Base
#   # This allows the app code to refresh
#   # without having to restart the server.
#   configure :development do
#     register Sinatra::Reloader
#   end

#   # Declares a route that responds to a request with:
#   #  - a GET method
#   #  - the path /
#   get '/' do
#     # The code here is executed when a request is received,
#     # and need to send a response. 

#     # We can simply return a string which
#     # will be used as the response content.
#     # Unless specified, the response status code
#     # will be 200 (OK).
#     return 'Some response data'
#   end
# end