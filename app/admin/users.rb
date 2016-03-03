# Export to CSV with the referrer_id
ActiveAdmin.register User do
  csv do
    column :id
    column :email
    column :referral_code
    column :referral_registered_number
    column :role
    column :referrer_id
    column :created_at
    column :updated_at
  end

  actions :index, :show
  
  filter :referrer, collection: proc { User.all.map{|a| [a.id]} }
  filter :email
  filter :referral_code
  filter :referral_registered_number
  filter :role, as: :select, collection: ["instructor", "student"]

end
