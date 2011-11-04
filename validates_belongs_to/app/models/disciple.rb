class Disciple < ActiveRecord::Base
  belongs_to :master

  validates_belongs_to :master
  validates_presence_of :name

  def learn
    to_be_learned = master.answer("What should I learn today?")
    memorize(to_be_learned)
  end

  def memorize(piece_of_wisdom)
    100.times {say_it_out_loud(piece_of_wisdom)}
  end

  private
  def say_it_out_loud(sentence)
    sentence
  end
end
