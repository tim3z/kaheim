ActiveAdmin.register Request do
  menu priority: 3

  index do
    column :title
    column :owner_name
    column :email
    column :blocked
    column :confirmed_at
    actions default: true do |item|
      link_to(item.blocked ? 'Freischalten' : 'Sperren', item.blocked ? unblock_admin_request_path(item) : block_admin_request_path(item), method: :put)
    end
  end

  controller do
    def permitted_params
      params.permit request: [:blocked]
    end
  end

  member_action :block, method: :put do
    Request.find(params[:id]).block!
    redirect_back(fallback_location: root_path, notice: "Gesuch geblockt!")
  end
  member_action :unblock, method: :put do
    Request.find(params[:id]).unblock!
    redirect_back(fallback_location: root_path, notice: "Gesuch entblockt!")
  end
end
