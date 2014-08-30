class AddCloumnToDictionaries < ActiveRecord::Migration
  def change
    add_column :dictionaries, :english, :string
    add_column :dictionaries, :chinese, :text
    add_column :dictionaries, :description, :text
  end
end
