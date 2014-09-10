module ItemsHelper
  def badges_for item
    result = ''
    result << content_tag(:span, t('helpers.mine'), class: 'label label-info') << ' ' if current_user == item.user
    result << content_tag(:span, t('items.outdated'), class: 'label label-danger') << ' ' if item.outdated?
    result << content_tag(:span, t('items.invisible'), class: 'label label-danger') unless item.visible?
    result.html_safe
  end

  def gender_icon gender
    case gender
      when 'female'
        content_tag(:i, '', class: 'fa fa-female')
      when 'male'
        content_tag(:i, '', class: 'fa fa-male')
      else
        content_tag :span, content_tag(:i, '', class: 'fa fa-female') + '/' + content_tag(:i, '', class: 'fa fa-male'), class: 'dontcare'
    end
  end

  def gender_select value
    content_tag(:button, id: 'gender-select-button', type: 'button', class: 'btn btn-default dropdown-toggle', 'data-toggle' => 'dropdown') do
      gender_icon(value) << ' ' <<
      content_tag(:span, '', class: 'caret')
    end <<
    content_tag(:ul, class: 'dropdown-menu dropdown-menu-auto', role: 'menu', 'data-no-turbolink' => true) do
      %w(female male dontcare).map do |gender|
        content_tag(:li, class: 'gender-select-item', 'data-gender' => gender) do
          link_to '#' do
            content_tag :span, class: 'gender-label' do
              gender_icon gender
            end
          end
        end
      end.join.html_safe
    end
  end
end