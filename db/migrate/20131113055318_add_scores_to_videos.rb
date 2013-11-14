class AddScoresToVideos < ActiveRecord::Migration
  def change
    add_column  :videos, :scores, :integer, :limit => 1
  end
end
