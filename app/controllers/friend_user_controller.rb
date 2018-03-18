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
 		if BlockUser.exists?(:email=>email,:block_email=>friend_email) || BlockUser.exists?(:email=>friend_email,:block_email=>email)
 		   return render :json => {:success => false}
 		end
 		#if they are connected as friends,retrun success is true
 		if FriendUser.exists?(:email=>email,:friend_email=>friend_email) || FriendUser.exists?(:email=>friend_email,:friend_email=>email)
 			return render :json => {:success => true}
 		end

 		#create a friend connection between two email addresses.
 		friend_user = FriendUser.create(:email=>email,:friend_email=>friend_email)

 		if friend_user.save
 			logger.info("[FriendUserController]create_friend == create a friend connection between two email addresses ,params ==#{params[:friends]}")
 			return render :json => {:success => true}
 		else
 			logger.info("[FriendUserController]create_friend == can not create a friend connection between two email addresses,error=#{friend_user.errors.full_messages} ,params ==#{params[:friends]}")
 			return render :json => {:success => false}
 		end
 		
 	end


 	#2. As a user, I need an API to retrieve the friends list for an email address.

 	def find_friend

 		if params[:email].blank?
 			logger.info("[FriendUserController]find_friend == email is blank !!!")
 			return render :json => {:success => false}
 		end
	
 		email = params[:email]

 		#get a list of friends
 		friend_emails = get_friend_email(email)

 		#get a list of block friends by email
 		block_mails = BlockUser.where(:email=>email).map(&:block_email)

 		friend_emails = friend_emails - block_mails
 		
 		logger.info("[FriendUserController]find_friend == friends list =======>#{friend_emails}")

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
 		
 		#get a list of friends
 		friend_emails = get_friend_email(email)

 		#get a list of block friends by email
 		block_mails = BlockUser.where(:email=>email).map(&:block_email)

 		friend_emails = friend_emails - block_mails

 		#get a list of friends
 		other_friend_emails = get_friend_email(other_email)

 		#get a list of block friends by other_email
 		block_mails = BlockUser.where(:email=>other_email).map(&:block_email)

 		other_friend_emails = other_friend_emails - block_mails

 		#get common friends list
 		common_emails = friend_emails & other_friend_emails

 		logger.info("[FriendUserController]find_common_friend == common friends ==#{common_emails}")

 		return render :json => {:success => true,:friends=>common_emails,:count=>common_emails.size}.to_json
 		
 	end

 	#4. As a user, I need an API to subscribe to updates from an email address.

 	def subscribe_updates

 		if params[:requestor].blank? || params[:target].blank?
 			logger.info("[FriendUserController]subscribe_updates == params is error ,params ==#{params[:friends]}")
 			return render :json => {:success => false}
 		end

 		requestor_email = params[:requestor]
 		target_email = params[:target]

 		if BlockUser.exists?(:email=>requestor_email,:block_email=>target_email)
 			logger.info("[FriendUserController]subscribe_updates == block updates,can not subscribe to updates ,params ==#{params}")
 		   return render :json => {:success => false}
 		end

 		if SubscribeUser.exists?(:email=>requestor_email,:subscribe_email=>target_email)
 			logger.info("[FriendUserController]subscribe_updates == subscribe to updates exist ,params ==#{params}")
 		   return render :json => {:success => true}
 		end
 		
 		subscribe_user = SubscribeUser.create(:email=>requestor_email,:subscribe_email=>target_email)

 		if subscribe_user.save
 			logger.info("[FriendUserController]subscribe_updates == subscribe to updates success ,params ==#{params}")
 			return render :json => {:success => true}
 		else
 			logger.info("[FriendUserController]subscribe_updates == can not subscribe to updates ,error=#{subscribe_user.errors.full_messages} ,params ==#{params}")
 			return render :json => {:success => false}
 		end
 		
 	end


 	#5. As a user, I need an API to block updates from an email address.

 	def block_updates

 		if params[:requestor].blank? || params[:target].blank?
 			logger.info("[FriendUserController]block_updates == params is error ,params ==#{params[:friends]}")
 			return render :json => {:success => false}
 		end

 		requestor_email = params[:requestor]
 		target_email = params[:target]
 		
 		if BlockUser.exists?(:email=>requestor_email,:block_email=>target_email)
 			logger.info("[FriendUserController]block_updates == block updates exist,params ==#{params}")
 			return render :json => {:success => true}
 		end
 		
 		block_user = BlockUser.create(:email=>requestor_email,:block_email=>target_email)

 		if block_user.save
 			friend_user = FriendUser.where(:email=>requestor_email,:friend_email=>target_email)	
 			friend_user.map(&:destroy)

 			subscribe_user = SubscribeUser.where(:email=>requestor_email,:subscribe_email=>target_email)
 			subscribe_user.map(&:destroy)

 			logger.info("[FriendUserController]block_updates == block updates success,params ==#{params}")

 			return render :json => {:success => true}
 		else
 			logger.info("[FriendUserController]block_updates == can not block updates ,error=#{block_user.errors.full_messages} ,params ==#{params}")
 			render :json => {:success => false}
 		end
 	end

 	#6. As a user, I need an API to retrieve all email addresses that can receive updates from an email address.

 	def retrieve_all_email

 		if params[:sender].blank?
 			logger.info("[FriendUserController]retrieve_all_email == params is error ,params ==#{params[:friends]}")
 			return render :json => {:success => false}
 		end

 		send_email = params[:sender]

 		block_mails = BlockUser.where(:email=>send_email).map(&:block_email)

 		logger.info("[FriendUserController]retrieve_all_email == block_mails ==#{block_mails}")

 		friend_emails = get_friend_email(send_email)

 		logger.info("[FriendUserController]retrieve_all_email == friend_emails ==#{friend_emails}")

 		subscribe_mails = SubscribeUser.where(:subscribe_email=>send_email).map(&:email)

 		logger.info("[FriendUserController]retrieve_all_email == subscribe_mails ==#{subscribe_mails}")

 		retrieve_mails = friend_emails + subscribe_mails - block_mails

 		logger.info("[FriendUserController]retrieve_all_email == retrieve_mails ==#{retrieve_mails}")

 		return render :json => {:success => true,:recipients=>retrieve_mails}
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
