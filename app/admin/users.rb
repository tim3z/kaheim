ActiveAdmin.register User do
  index do
    column :name
    column :email
    column :unlocked
    column :admin
    column :confirmed_at
    actions
  end

  filter :email

  form do |f|
    f.inputs "User Details" do
      f.input :name, input_html: { disabled: true }
      f.input :email, input_html: { disabled: true }
      f.input :unlocked
      f.input :admin
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit user: [:unlocked, :admin]
    end
  end
end
