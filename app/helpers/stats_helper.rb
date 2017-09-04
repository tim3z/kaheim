module StatsHelper
  def create_day_of_year_averages(type)
    oldest_item = HistoryItem.order(created_at: :asc).first
    return [] unless oldest_item
    start_date = oldest_item.created_at.at_beginning_of_year.next_year
    start_date = 1.year.ago if start_date > 1.year.ago
    data = HistoryItem.all.where('created_at > ?', start_date).sort_by {|item| item.created_at.yday}
    data = data.group_by {|item| l(item.created_at, format: t('stats.statistics.date_format'))}
    data.each { |date, items| data[date] = (items.sum(&type) / items.count)}
  end

  def create_month_averages(type)
    HistoryItem.group_by_month(:created_at).average(type)
  end
end