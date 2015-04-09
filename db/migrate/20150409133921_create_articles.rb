class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.integer :position
      t.references :single_player_game

      t.timestamps
    end
    add_index :articles, :single_player_game_id
  end
end
