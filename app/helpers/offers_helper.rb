module OffersHelper
  def value_or_karlsruhe value
    (value != '' && value) || 'Karlsruhe'
  end
end
