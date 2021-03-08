require "sinatra"

class MyMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    puts "hi"
    @app.call(env)
  end
end

use MyMiddleware

get '/' do
  'Hello world!'
end

