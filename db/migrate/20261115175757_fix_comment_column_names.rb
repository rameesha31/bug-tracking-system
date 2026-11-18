class FixCommentColumnNames < ActiveRecord::Migration[7.2]
  def change
    rename_column :comments, :bugs_id, :bug_id
    rename_column :comments, :comments, :content
  end
end
