class CreateScores < ActiveRecord::Migration[7.0]
  def change
    create_table :scores do |t|
      t.integer :points
      t.string :playerid
      t.timestamps
    end
  end
end
