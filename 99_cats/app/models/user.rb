# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    validates :username, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence:true
    after_initialize ensure_session_token

    def reset_session_token!
        self.session_token ||= SecureRandom::urlsafe_base64
    end

    def password=(password)
        password_digest = Bcrypt::Password.create(password)
    end

    def is_password?(password)
        another_password = Bcrypt::Password.new(password_digest)
        another_password.is_password?(password)
    end

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        if user && user.is_password?(password)
            user
        else 
            nil
        end
    end
end     
