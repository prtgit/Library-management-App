class Room < ApplicationRecord
  has_many :bookings
  VALID_ROOMSIZE_REGEX = /(4|6|12)/
  validates :size, presence: true,
            format: { with: VALID_ROOMSIZE_REGEX }
  validates :number, presence: true, uniqueness: true
  VALID_BUILDING_REGEX = /(D.H.Hill|James.B.Hunt)/
  validates :building, presence: true,
            format: { with: VALID_BUILDING_REGEX }
  VALID_Status_REGEX = /(Available)/
  validates :status, presence: true,
            format: { with: VALID_Status_REGEX }
end
