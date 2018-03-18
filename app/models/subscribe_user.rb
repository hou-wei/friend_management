# encoding: utf-8
class SubscribeUser < ActiveRecord::Base
	acts_as_paranoid column: :delete_at

	validates_presence_of :email,:subscribe_email ,:message => I18n.t("errors.blank")

	validates_format_of      :email,
                             :with                       => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                             :message                    => I18n.t("errors.invalid"),
                             :if                         => proc { |u| u.errors.get(:email).blank? }

    validates_format_of      :subscribe_email,
                             :with                       => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                             :message                    => I18n.t("errors.invalid"),
                             :if                         => proc { |u| u.errors.get(:subscribe_email).blank? }
end