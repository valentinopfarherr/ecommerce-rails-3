#!/bin/env ruby
# encoding: utf-8
# ApplicationController is the main controller of the application
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
end
