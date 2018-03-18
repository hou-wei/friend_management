# encoding: utf-8
class FriendUser < ActiveRecord::Base
	acts_as_paranoid column: :delete_at

end