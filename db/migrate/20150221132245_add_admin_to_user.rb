class AddAdminToUser < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean

    User.all.each{ |u| u.update_attribute(:admin, false) }
    User.first.update_attribute(:admin, true)
  end
end
