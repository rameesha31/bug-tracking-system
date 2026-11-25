class UpdateEmailLogsForEmailKey < ActiveRecord::Migration[7.2]
  def change
    remove_index :email_logs, :bug_id

    add_column :email_logs, :email_key, :string, null: false

    add_index :email_logs, :email_key, unique: true  
  end
end
