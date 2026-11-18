class CreateBugs < ActiveRecord::Migration[7.2]
  def change
    create_table :bugs do |t|
      t.string :title
      t.text :description
      t.integer :priority , default: 0
      t.integer :status , default: 0
      t.references :project, null: false, foreign_key: true
      t.references :assigned_to , null: true , foreign_key: {to_table: :users}
      t.references :reported_by , null: false , foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
