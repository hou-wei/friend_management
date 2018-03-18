# encoding: utf-8
class BlockUser < ActiveRecord::Base
	acts_as_paranoid column: :delete_at

end