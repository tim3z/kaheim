namespace :kaheim do
  desc 'sends out notifications for newly invisible items and deletes items too old'
  task handle_obsolete: :environment do
    Offer.outdated.find_each do |offer|
      handle_obsolete offer
    end
    Request.outdated.find_each do |request|
      handle_obsolete request
    end
  end

  desc 'creates new history item'
  task create_history_item: :environment do
    offers_count = Offer.visible_for(nil, Offer).count
    requests_count = Request.visible_for(nil, Request).count
    HistoryItem.create({offers_count: offers_count, requests_count: requests_count})
  end

  def handle_obsolete item
    reactivator = ItemReactivator.find_by item: item
    if reactivator.nil?
      reactivator = ItemReactivator.create! item: item
      ItemMailer.reactivate_item_mail(item, reactivator.token).deliver_now
    elsif reactivator && reactivator.created_at < 100.days.ago
      reactivator.destroy
      item.destroy
    end
  end
end

