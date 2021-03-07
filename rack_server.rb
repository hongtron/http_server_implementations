#!/usr/bin/env ruby

require 'logger'
require 'rack'

@@logger = Logger.new(STDOUT)
@@logger.level = Logger::DEBUG


class MiddlewareOne
  def initialize(app)
    @app = app
  end

  def call(env)
    @@logger.debug("middleware one")
    @app.call(env)
  end
end

class MiddlewareTwo
  def initialize(app)
    @app = app
  end

  def call(env)
    @@logger.debug("middleware two")
    @app.call(env)
  end
end

class App
  def call(env)
    [200, {"Content-Type" => "text/plain"}, ["working"]]
  end
end
