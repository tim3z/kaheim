ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t('active_admin.dashboard.title') }

  content title: proc{ I18n.t('active_admin.dashboard.title') } do
    columns do
      column do
        panel I18n.t('active_admin.dashboard.not_unlocked') do
          h6 I18n.t('activerecord.models.offer.other')
          table_for(Offer.locked) do
            column :title
            column :description
            column I18n.t('active_admin.actions.title') do |offer|
              link_to(I18n.t('active_admin.actions.show'), offer) + ' ' +
              link_to(I18n.t('active_admin.actions.unlock'), unlock_admin_user_path(offer.user), method: :put) + ' ' +
              link_to(I18n.t('active_admin.actions.show_in_admin_panel'), admin_offer_path(offer))
            end
          end
          h6 I18n.t('activerecord.models.request.other')
          table_for(Request.locked) do
            column :title
            column :description
            column I18n.t('active_admin.actions.title') do |request|
              link_to(I18n.t('active_admin.actions.show'), request) + ' ' +
              link_to(I18n.t('active_admin.actions.unlock'), unlock_admin_user_path(request.user), method: :put) + ' ' +
              link_to(I18n.t('active_admin.actions.show_in_admin_panel'), admin_request_path(request))
            end
          end
        end
      end
    end
  end
end
