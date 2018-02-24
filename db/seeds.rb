# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Seed customers - User
user = {}
user['password'] = 'asdf'

ActiveRecord::Base.transaction do
  5.times do 
    user['first_name'] = Faker::Name.first_name 
    user['last_name'] = Faker::Name.last_name
    user['email'] = Faker::Internet.email
    user['gender'] = rand(1..2)
    user['phone'] = Faker::PhoneNumber.phone_number
    user['birthdate'] = Faker::Date.between(50.years.ago, Date.today)
    user['role'] = 0

    User.create(user)
  end
end 

# Seed customers - Admin
user = {}
user['password'] = 'asdf'

ActiveRecord::Base.transaction do
  user['first_name'] = Faker::Name.first_name 
  user['last_name'] = Faker::Name.last_name
  user['email'] = "superduperadmin@pairbnb.com"
  user['gender'] = rand(1..2)
  user['phone'] = Faker::PhoneNumber.phone_number
  user['birthdate'] = Faker::Date.between(50.years.ago, Date.today)
  user['role'] = 2

  User.create(user)
end 

# Seed Listings
listing = {}
uids = []
User.all.each { |u| uids << u.id }

ActiveRecord::Base.transaction do
  100.times do 
    listing['name'] = Faker::App.name
    listing['place_type'] = rand(1..3)
    listing['property_type'] = ["House", "Entire Floor", "Condominium", "Villa", "Townhouse", "Castle", "Treehouse", "Igloo", "Yurt", "Cave", "Chalet", "Hut", "Tent", "Other"].sample

    listing['room_number'] = rand(0..5)
    listing['bed_number'] = rand(1..6)
    listing['guest_number'] = rand(1..10)
    listing['kitchen'] = [true, false].sample
    listing['amenities'] = []
    listing['amenities'] << ["gym", "pool", "sauna", "bakery"].sample

    listing['country'] = Faker::Address.country
    listing['state'] = Faker::Address.state
    listing['city'] = Faker::Address.city
    listing['zipcode'] = Faker::Address.zip_code
    listing['address'] = Faker::Address.street_address

    listing['price'] = rand(80..500)
    listing['description'] = Faker::Hipster.sentence
    listing['tags'] = []
    listing['tags'] << ["Big", "Cool", "Awesome", "Pretty", "Beautify", "Large"].sample

    listing['user_id'] = uids.sample

    Listing.create(listing)
  end
end