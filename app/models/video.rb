class Video < ActiveRecord::Base
  validates :name,  presence: true, length: { minmum: 3, maximum: 20 }
  validates :url,  presence: true
end
