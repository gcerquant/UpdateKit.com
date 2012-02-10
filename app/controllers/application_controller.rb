# UpdateKit.com ApplicationController
class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => "Access denied."
  end
  
  
  def cocoa_framework_version
    render :json => { :current_version => "0.1" }
  end

end
