# ErrorsController handles errors of the application.
class ErrorsController < ActionController::Base
  def not_found
    if env["REQUEST_PATH"] =~ /^\/api/
      render :json => {:error => "not-found"}.to_json, :status => 404
    else
      render :text => "resource Not found", :status => 404 
    end
  end

  def exception
    if env["REQUEST_PATH"] =~ /^\/api/
      render :json => {:error => "internal-server-error"}.to_json, :status => 500
    else
      render :text => "internal Server Error", :status => 500
    end
  end
end