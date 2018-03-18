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


 	#2. As a user, I need an API to retrieve the friends list for an email address.

 	def find_friend

 		email = params[:email]
 		friend_emails = get_friend_email(email)
 		
 		return render :json => {:success => true,:friends=>friend_emails,:count=>friend_emails.size}.to_json
 		
 	end

 	#3. As a user, I need an API to retrieve the common friends list between two email addresses.

 	def find_common_friend

 		if params[:friends].blank? || params[:friends].size != 2
 			logger.info("[FriendUserController]find_common_friend == params is error ,params ==#{params[:friends]}")
 			return render :json => {:success => false}
 		end
 		
 		email = params[:friends][0]
 		other_email = params[:friends][1]
 		
 		friend_emails = get_friend_email(email)
 		other_friend_emails = get_friend_email(other_email)

 		common_emails = friend_emails & other_friend_emails

 		return render :json => {:success => true,:friends=>common_emails,:count=>common_emails.size}.to_json
 		
 	end
	


 	private

 	def get_friend_email(email)

 		friend_emails = []

 		friend_users = FriendUser.where(["email = ? ",email])

 		friend_emails << friend_users.map(&:friend_email)

 		friend_users = FriendUser.where(["friend_email = ? ",email])

 		friend_emails << friend_users.map(&:email)

 		friend_emails.flatten!

 		return friend_emails

 	end 

 	def get_layout
      return false
    end
end
