# require 'hex/square_grid'

class TestController < ApplicationController

  include MapHandler

  def show
    set_map
  end

end
