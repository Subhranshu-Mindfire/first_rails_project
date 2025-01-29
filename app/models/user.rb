class User < ApplicationRecord

    has_secure_password
    has_many :user_roles, dependent: :destroy
    has_many :roles, through: :user_roles

    before_destroy :check_if_user_is_owner

    validates :first_name, presence: true
    validates :email, presence: true, uniqueness: true

    validate :must_have_role

    def must_have_role
        if roles.empty?
            errors.add(:roles, "Must have One Role")
        end
    end

    def check_if_user_is_owner
      owner_role = Role.find_by(title: "Owner")
      is_owner = roles.exists?(id: owner_role.id)

      
    #   binding.pry
      
      if is_owner
          errors.add(:roles, "Owner Can not be deleted")
      end
    end
end
