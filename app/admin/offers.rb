ActiveAdmin.register Offer do
  menu priority: 3

  index do
    column :title
    column :owner_name
    column :email
    column :blocked
    column :confirmed_at
    actions default: true do |item|
      link_to(item.blocked ? 'Freischalten' : 'Sperren', item.blocked ? unblock_admin_offer_path(item) : block_admin_offer_path(item), method: :put)
    end
  end

  controller do
    def permitted_params
      params.permit offer: [:blocked]
    end
  end

  member_action :block, method: :put do
    Offer.find(params[:id]).block!
    redirect_back(fallback_location: root_path, notice: "Angebot geblockt!")
  end
  member_action :unblock, method: :put do
    Offer.find(params[:id]).unblock!
    redirect_back(fallback_location: root_path, notice: "Angebot entblockt!")
  end
end
