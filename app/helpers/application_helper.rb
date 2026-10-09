module ApplicationHelper
  include Pagy::Frontend

  BADGE_COLORS = {
    "active" => "bg-green-100 text-green-800",
    "available" => "bg-green-100 text-green-800",
    "paid" => "bg-green-100 text-green-800",
    "scheduled" => "bg-blue-100 text-blue-800",
    "reserved" => "bg-yellow-100 text-yellow-800",
    "in_progress" => "bg-yellow-100 text-yellow-800",
    "maintenance" => "bg-yellow-100 text-yellow-800",
    "cancelled" => "bg-red-100 text-red-800"
  }.freeze

  def enum_label(model, attribute, value)
    t("enums.#{model.model_name.i18n_key}.#{attribute}.#{value}") if value.present?
  end

  def enum_options(model_class, attribute)
    model_class.public_send(attribute.to_s.pluralize).keys.map { |key| [ enum_label(model_class, attribute, key), key ] }
  end

  def status_badge(record, attribute = :status)
    value = record.public_send(attribute)
    tag.span enum_label(record, attribute, value),
      class: [ "inline-flex rounded-full px-2.5 py-0.5 text-xs font-medium", BADGE_COLORS.fetch(value, "bg-gray-100 text-gray-700") ]
  end

  def field_classes(record, attribute)
    [ "input", ("input-error" if record.errors[attribute].any?) ]
  end

  def nav_link(label, path)
    active = request.path.start_with?(path)
    link_to label, path, class: [ "rounded-md px-3 py-2 text-sm font-medium",
      active ? "bg-blue-50 text-blue-700" : "text-gray-600 hover:bg-gray-100 hover:text-gray-900" ]
  end

  def pagination(pagy)
    pagy_nav(pagy).html_safe if pagy.pages > 1
  end
end
