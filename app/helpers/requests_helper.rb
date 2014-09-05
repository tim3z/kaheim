module RequestsHelper
  def from_date_info request
    if request.from_date && !request.from_date.past?
      "#{t 'requests.show.from'} #{l request.from_date}"
    else
      t 'requests.show.now'
    end
  end
end
