# encoding: utf-8
class FriendUser < ActiveRecord::Base
	acts_as_paranoid column: :delete_at

	validates_presence_of :email,:friend_email ,:message => I18n.t("errors.blank")

	validates_format_of      :email,
                             :with                       => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                             :message                    => I18n.t("errors.invalid"),
                             :if                         => proc { |u| u.errors.get(:email).blank? }

    validates_format_of      :friend_email,
                             :with                       => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                             :message                    => I18n.t("errors.invalid"),
                             :if                         => proc { |u| u.errors.get(:friend_email).blank? }
end