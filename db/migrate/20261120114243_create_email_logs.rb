class CreateEmailLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :email_logs do |t|
      t.references :bug, null: false, foreign_key: true, index: { unique: true }
      t.string :recipient_email, null: false
      t.string :subject
      t.integer :status, default: 0, null: false
      t.datetime :sent_at

      t.timestamps
    end
  end
end