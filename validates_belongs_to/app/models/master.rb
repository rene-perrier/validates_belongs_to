class Master < ActiveRecord::Base
  validates_presence_of :name, :wisdom

  def answer(question)
    meditate
    return @a_really_wise_answer
  end

  private

  def meditate
    # meditate for a while (but in reality, the master might perform some very complex
    # computation, requiring a lot of external resources)
    sleep 5.minutes
    @a_really_wise_answer = "whatever..."
  end
end
