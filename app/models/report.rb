class Report < ActiveRecord::Base
  def readonly?
    true
  end
end
