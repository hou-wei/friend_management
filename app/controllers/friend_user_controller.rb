class FriendUserController < ApplicationController

	layout :get_layout

	#1. As a user, I need an API to create a friend connection between two email addresses.

 	def create_friend
 		
 		if params[:friends].blank? || params[:friends].size != 2
 			logger.info("[FriendUserController]create_friend == params is error ,params ==#{params[:friends]}")
 			return render :json => {:success => false}
 		end
 		email = params[:friends][0]
 		friend_email = params[:friends][1]

 		# block updates from an email address,if they are not connected as friends, then no new friends connection can be added
 		if BlockUser.exists?(:requestor_email=>email,:target_email=>friend_email) || BlockUser.exists?(:requestor_email=>friend_email,:target_email=>email)
 		   return render :json => {:success => false}
 		end
 		#if they are connected as friends,retrun success is true
 		if FriendUser.exists?(:email=>email,:friend_email=>friend_email) || FriendUser.exists?(:email=>friend_email,:friend_email=>email)
 			return render :json => {:success => true}
 		end

 		#create a friend connection between two email addresses.
 		FriendUser.create!(:email=>email,:friend_email=>friend_email)

 		return render :json => {:success => true}
 	end
	


 	private

 	def get_layout
      return false
    end
end
