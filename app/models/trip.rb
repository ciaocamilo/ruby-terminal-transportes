class Trip < ApplicationRecord
    belongs_to :vehicle
    belongs_to :origin, :class_name => 'City'
    belongs_to :destiny, :class_name => 'City'
end
