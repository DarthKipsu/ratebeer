class AddConfirmedToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :confirmed, :boolean, default: false

    Membership.all.each do |m|
      if m.user_id.eql? 1
        m.confirmed = true
        m.save
      end
    end
  end
end
