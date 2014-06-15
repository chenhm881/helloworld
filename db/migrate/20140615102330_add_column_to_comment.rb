class AddColumnToComment < ActiveRecord::Migration
  def change
  	add_column :comments, :article_id, :integer, default: false
  end
end
