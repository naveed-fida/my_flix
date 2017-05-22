class CreateQueueItems < ActiveRecord::Migration
  def change
    create_table :queue_items do |t|
      t.integer :position
      t.references :video
      t.references :user
      t.timestamps
    end
  end
end
