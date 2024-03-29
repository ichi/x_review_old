# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string
#  last_sign_in_ip     :string
#

class User < ActiveRecord::Base
  devise :trackable, :omniauthable, omniauth_providers: %i(twitter)

  has_many :authorizations
  has_many :groups_users
  has_many :groups, through: :groups_users

  validates :name,
    presence: true

  def role_on(group)
    groups_users.find_by(group: group).role
  end

  class << self

    def from_omniauth(auth, user)
      authorization = Authorization.find_or_initialize_by(
        provider: auth.provider,
        uid: auth.uid.to_s,
        token: auth.credentials.token,
        secret: auth.credentials.secret)

      if authorization.user.blank?
        user ||= User.create!(name: auth.info.nickname)

        authorization.update! user_id: user.id
      end

      authorization.user
    end
  end
end
