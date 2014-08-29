ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel 'Nicht freigeschaltet' do
          h6 'Angebote'
          table_for(Offer.locked) do
            column :title
            column :description
            column 'Aktionen' do |offer|
              link_to('Anzeigen', offer) + ' ' +
              link_to('Freischalten', unlock_admin_user_path(offer.user), method: :put) + ' ' +
              link_to('Im Admin Panel Anzeigen', admin_offer_path(offer))
            end
          end
          h6 'Gesuche'
          table_for(Request.locked) do
            column :title
            column :description
            column 'Aktionen' do |request|
              link_to('Anzeigen', request) + ' ' +
              link_to('Freischalten', unlock_admin_user_path(request.user), method: :put) + ' ' +
              link_to('Im Admin Panel Anzeigen', admin_request_path(request))
            end
          end
        end
      end
    end
  end
end
