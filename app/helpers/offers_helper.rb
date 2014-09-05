module OffersHelper
  def date_info offer
    out = t('offers.show.from') << ' ' << l(offer.from_date)
    out << t('offers.show.to') << ' ' << l(offer.to_date) if offer.to_date
    out
  end

  def address_info offer
    if offer.district && offer.district != ''
      "#{offer.district}, #{offer.street}"
    else
      offer.street
    end
  end
end
