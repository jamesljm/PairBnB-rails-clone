class Listing < ApplicationRecord
    # === Associations
    belongs_to :user
    has_many :reservations

    attr_accessor :images
    
    # === Roles
    enum place_type: { heaven: 1, earth: 2, hell: 3 }

    # carrierwave images
    mount_uploaders :images, ImagesUploader

    # === Validations
    # validates :name, presence: true
    # validates :room_number    

    # === Search Model
    # search scope: name, country, state, city, tags
    scope :search,          -> (keyword) { where("name like ? OR country LIKE ? OR state LIKE ?", "#{keyword}%", "#{keyword}%", "#{keyword}%") }
    # filter scope: place_type, property_type, price, bed number, room number, amenities, kitchen
    # scope :with_amenities, ->(amenities) { where('listings.amenities && array[?]', amenities.sort) }
    scope :place_type, -> (place_type) { where place_type: place_type }
    scope :amenities, -> (amenities) { where amenities: amenities }
    scope :property_type, -> (property_type) { where property_type: property_type }


    scope :with_place_type, ->(place_type) { where("place_type LIKE ?", "heaven") }
    scope :testing,         -> (keyword) { where("name like ?", "tree") }

end