class ChangeColumnToVideos < ActiveRecord::Migration
  def change
    change_column :videos, :url, :text
  end
end
