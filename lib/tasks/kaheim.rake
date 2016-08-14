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

  def handle_obsolete item
    reactivator = ItemReactivator.find_by item: item
    if reactivator.nil?
      reactivator = ItemReactivator.create! item: item
      UserMailer.reactivate_item_mail(item, reactivator.token).deliver_now
    elsif reactivator && reactivator.created_at < 100.days.ago
      reactivator.destroy
      item.destroy
    end
  end
end

