class ErrorsController < ApplicationController
  def error
    render params[:error_code].to_s
  end
end
