class ErrorsController < ApplicationController

  layout 'application'

  def not_found
    render status: 404
  end
end
