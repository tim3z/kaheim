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
      f.input :name, input_html: { disabled: true }
      f.input :email, input_html: { disabled: true }
      f.input :admin
    end
    f.actions
  end
end
