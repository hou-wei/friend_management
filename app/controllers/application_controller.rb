class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  	protect_from_forgery with: :exception

  	skip_before_filter :verify_authenticity_token

  	around_filter :around_controller

  	def around_controller
	    begin
	    	yield
	    rescue Exception => e
	    	logger.info("[ApplicationController] around_controller == system error======>#{e}")
	    	return render :json => {:success => false}
	    end
	end
end
