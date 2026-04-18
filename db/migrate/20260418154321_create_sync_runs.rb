class CreateSyncRuns < ActiveRecord::Migration[8.1]
  def change
    create_table :sync_runs do |t|
      t.references :data_source, null: false, foreign_key: true
      t.string :status, null: false
      t.datetime :started_at
      t.datetime :finished_at
      t.integer :items_count, null: false, default: 0
      t.text :error_message
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :sync_runs, :status
  end
end
