module ApplicationHelper
  def currency_code(currency)
    "#{currency.converter} #{currency.code}"
  end

  def active_class(controller)
    controller_name == controller && :active
  end
end
