class Listing < ApplicationRecord
    belongs_to :user
    has_many :reservations

    attr_accessor :images
    
    # carrierwave images
    mount_uploaders :images, ImagesUploader

    # validates :name, presence: true
    # validates :room_number
    
    enum place_type: { heaven: 1, earth: 2, hell: 3 }
end