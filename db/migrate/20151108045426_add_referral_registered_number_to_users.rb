class AddReferralRegisteredNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :referral_registered_number, :string, default: 0
  end
end
