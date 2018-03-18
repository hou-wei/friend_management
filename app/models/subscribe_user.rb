# encoding: utf-8
class SubscribeUser < ActiveRecord::Base
	acts_as_paranoid column: :delete_at

end