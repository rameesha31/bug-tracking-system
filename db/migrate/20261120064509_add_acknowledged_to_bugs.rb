class AddAcknowledgedToBugs < ActiveRecord::Migration[7.2]
  def change
    add_column :bugs, :acknowledged, :boolean, default:false, null:false
  end
end
