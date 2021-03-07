#!/usr/bin/env ruby

require 'rack'

class MiddlewareOne
  attr_reader :logger

  def initialize(app, logger)
    @app = app
    @logger = logger
  end

  def call(env)
    logger.debug("middleware one")
    @app.call(env)
  end
end

class MiddlewareTwo
  attr_reader :logger

  def initialize(app, logger)
    @app = app
    @logger = logger
  end

  def call(env)
    logger.debug("middleware two")
    @app.call(env)
  end
end

class App
  attr_reader :logger

  def initialize(logger)
    @logger = logger
  end

  def call(env)
    logger.debug(env["HTTP_FOO"])
    [200, {"Content-Type" => "text/plain"}, ["working"]]
  end
end
