class AbilitiesUser < ActiveRecord::Base
	belongs_to :user
	belongs_to :ability
end
