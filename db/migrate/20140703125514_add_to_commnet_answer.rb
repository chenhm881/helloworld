class AddToCommnetAnswer < ActiveRecord::Migration
   def change
      add_column :comments, :answer, :string
   end
end
