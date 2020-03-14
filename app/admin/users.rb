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
      f.input :password
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit user: [:name, :email, :admin, :password]
    end
  end
end
