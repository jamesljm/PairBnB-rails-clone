class User < ApplicationRecord
  include Clearance::User

  has_many :authentications, dependent: :destroy
  has_many :listings
  has_many :reservations

  # enum value will represent the data type
  enum gender: { male: 0, female: 1, not_sure: 2, prefer_not_to_disclose: 3 }
  enum role: { customer: 0, moderator: 1, superadmin: 2 }

  # carrierwave avatar
  mount_uploader :avatar, ImageUploader

  def self.create_with_auth_and_hash(authentication, auth_hash)
    user = self.create!(
      first_name: auth_hash["extra"]["raw_info"]["first_name"],
      last_name: auth_hash["extra"]["raw_info"]["last_name"],
      password: SecureRandom.hex(10),
      email: auth_hash["extra"]["raw_info"]["email"],
      gender: auth_hash["extra"]["raw_info"]["gender"]
      # birthdate: auth_hash["extra"]["raw_info"]["birthday"]
      # get facebook profile picture
    )
    user.authentications << authentication
    return user
  end
 
  # grab fb_token to access Facebook for user data
  def fb_token
    x = self.authentications.find_by(provider: 'facebook')
    return x.token unless x.nil?
  end

  # Getter
  def name
    "#{self[:first_name]} #{self[:last_name]}"
   end
end
