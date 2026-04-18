class CreateIndicators < ActiveRecord::Migration[8.1]
  def change
    create_table :indicators do |t|
      t.references :data_source, null: false, foreign_key: true
      t.string :name, null: false
      t.string :slug, null: false
      t.string :category, null: false
      t.string :unit
      t.string :source_code
      t.text :description
      t.boolean :active, null: false, default: true
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :indicators, :slug, unique: true
    add_index :indicators, :category
  end
end
