class User < ApplicationRecord
    has_many :user_roles
    has_many :roles, through: :user_roles

    validates :first_name, presence: true
    validates :email, presence: true

    validate :must_have_role

    def must_have_role
        if roles.empty?
            errors.add(:roles, "Must have One Role")
        end
    end
end
