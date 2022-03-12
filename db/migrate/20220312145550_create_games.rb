class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :result
      t.belongs_to :player, null: false, foreign_key: true
      t.belongs_to :dealer, null: false, foreign_key: true
      t.belongs_to :deck, null: false, foreign_key: true

      t.timestamps
    end
  end
end
