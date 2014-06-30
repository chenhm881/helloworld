class AddColumnUserPasswordDigest < ActiveRecord::Migration
  def change
  	add_column :users, :password_digest, :string, default: false

  end
end
