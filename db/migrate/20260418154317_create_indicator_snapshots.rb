class CreateIndicatorSnapshots < ActiveRecord::Migration[8.1]
  def change
    create_table :indicator_snapshots do |t|
      t.references :indicator, null: false, foreign_key: true
      t.string :place_code
      t.string :place_name
      t.string :place_type
      t.date :reference_date, null: false
      t.decimal :value, precision: 15, scale: 4
      t.jsonb :raw_payload, null: false, default: {}
      t.datetime :fetched_at, null: false

      t.timestamps
    end

    add_index :indicator_snapshots,
              [ :indicator_id, :reference_date, :place_code ],
              unique: true,
              name: "idx_indicator_snapshots_uniqueness"
  end
end
