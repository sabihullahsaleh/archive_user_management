class AddAaaToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :archive_number, :string
    add_column :users, :archived_at, :datetime
  end
end
