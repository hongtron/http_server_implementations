require 'logger'
require './rack_server'

logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

use MiddlewareOne, logger
use MiddlewareTwo, logger
run App.new(logger)
