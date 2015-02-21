class AddAdminToUser < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean

    User.all.each{ |u| u.update_attribute(:admin, false) }
  end
end
