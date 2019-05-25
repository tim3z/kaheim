ActiveAdmin.register User do
  menu priority: 2

  index do
    column :name
    column :email
    column :unlocked
    column :admin
    column :confirmed_at
    actions default: true do |user|
      link_to( user.unlocked? ? 'Sperren' : 'Freischalten', user.unlocked? ? lock_admin_user_path(user) : unlock_admin_user_path(user), method: :put)
    end
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
