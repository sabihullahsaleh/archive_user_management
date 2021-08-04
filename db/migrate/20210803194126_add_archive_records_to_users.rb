class AddArchiveRecordsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :archived_by, :integer
    add_column :users, :unarchived_by, :integer
    add_column :users, :unarchived_at, :datetime
  end
end
