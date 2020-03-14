ActiveAdmin.register User do
  menu priority: 3

  index do
    column :name
    column :email
    column :unlocked
    column :admin
    column :confirmed_at
    actions default: true
  end

  filter :email

  form do |f|
    f.inputs "User Details" do
      f.input :name
      f.input :email
      f.input :admin
    end
    f.actions
  end
end
