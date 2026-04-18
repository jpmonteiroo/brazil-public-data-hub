class CreateDataSources < ActiveRecord::Migration[8.1]
  def change
    create_table :data_sources do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :base_url, null: false
      t.boolean :active, null: false, default: true
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :data_sources, :slug, unique: true
  end
end
