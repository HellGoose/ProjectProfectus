class Ability < ActiveRecord::Base
	has_many :userAbilities, class_name: "AbilitiesUser"
end
