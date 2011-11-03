class Disciple < ActiveRecord::Base
  belongs_to :master

  validates_belongs_to :master
  validates_presence_of :name
end
