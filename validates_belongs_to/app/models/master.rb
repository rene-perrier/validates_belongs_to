class Master < ActiveRecord::Base
  validates_presence_of :name, :wisdom
end
