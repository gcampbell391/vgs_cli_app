class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.integer :card_value
      t.string :card_name
      t.belongs_to :deck, null: false, foreign_key: true

      t.timestamps
    end
  end
end
