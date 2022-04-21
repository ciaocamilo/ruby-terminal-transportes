class City < ApplicationRecord
    has_many :origin_cities, :class_name => 'Trip', :foreign_key => 'origin_id'
    has_many :destiny_cities, :class_name => 'Trip', :foreign_key => 'destiny_id'
end
