class Video < ActiveRecord::Base
  validates :name,  presence: true, length: { minmum: 3, maximum: 20 }
  validates :description,  presence: true, length: { maximum: 100 }
  validates :url,  presence: true
end
