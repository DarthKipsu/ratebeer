class AddSuspendedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :suspended, :boolean

    User.all.each{ |u| u.update_attribute(:suspended, false) }
  end
end
