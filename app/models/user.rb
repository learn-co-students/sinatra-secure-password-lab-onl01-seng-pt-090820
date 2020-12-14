class User < ActiveRecord::Base
    has_secure_password validations: true
    include BCrypt
end
