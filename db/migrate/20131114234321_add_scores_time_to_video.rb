class AddScoresTimeToVideo < ActiveRecord::Migration
  def change
    change_column  :videos, :scores, :integer
    add_column :videos, :scores_times, :integer
  end
end