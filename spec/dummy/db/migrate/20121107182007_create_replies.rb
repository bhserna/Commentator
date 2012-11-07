class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.text :message
      t.references :comment

      t.timestamps
    end
    add_index :replies, :comment_id
  end
end
