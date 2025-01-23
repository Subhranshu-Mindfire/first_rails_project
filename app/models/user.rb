class User < ApplicationRecord
    has_many :user_roles
    has_many :roles, through: :user_roles

    validates :first_name, presence: true
    validates :email, presence: true
end
