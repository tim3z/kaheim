module ItemsHelper
  def badges_for item
    result = ''
    result << content_tag(:span, t('helpers.mine'), class: 'label label-info') << ' ' if current_user == item.user
    result << content_tag(:span, t('item.outdated'), class: 'label label-danger') << ' ' if item.outdated?
    result << content_tag(:span, t('item.invisible'), class: 'label label-danger') unless item.visible?
    result.html_safe
  end
end