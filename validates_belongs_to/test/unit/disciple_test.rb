require 'test_helper'

class DiscipleWithNoBTValidation < ActiveRecord::Base
  set_table_name "disciples"

  belongs_to :master
  validates_presence_of :name
  # note: no validates_belongs_to validation for this class of Disciples
end


class DiscipleTest < ActiveSupport::TestCase

  def assert_valid(record)
    assert record.valid?, record.errors.full_messages.join("\n")
  end

  def assert_not_valid(record, message='expected not to be valid, but was valid')
    assert !record.valid?, message
  end

  test "disciple valid but sql exception when missing master id" do
    disciple = DiscipleWithNoBTValidation.new(:name => "no master")
    assert_valid disciple
    assert_raises(ActiveRecord::StatementInvalid) {disciple.save!}
  end

  test "disciple valid but sql exception when invalid master id" do
    disciple = DiscipleWithNoBTValidation.new(:name => "invalid master id", :master_id => -1)
    assert_valid disciple
    assert_raises(ActiveRecord::StatementInvalid) {disciple.save!}
  end

  test "disciple invalid when missing master id" do
    disciple = Disciple.new(:name => "no master")
    assert_not_valid disciple
    assert_equal "is invalid or missing", disciple.errors.on(:master)
  end

  test "disciple invalid when invalid master id" do
    disciple = Disciple.new(:name => "invalid master id", :master_id => -1)
    assert_not_valid disciple
    assert_equal "is invalid or missing", disciple.errors.on(:master)
  end

  test "disciple valid and can save when valid id" do
    master = masters(:yoda)
    disciple = Disciple.new(:name => "valid", :master => master)
    assert_valid disciple
    disciple.save!
  end

  test "master belongs_to is new and valid" do
    master = Master.new(:name => "Just testing", :wisdom => "not really")
    assert_valid master
    disciple = Disciple.new(:name => "valid", :master => master)
    assert_valid disciple
    disciple.save!
  end

  test "master belongs_to is new and invalid" do
    master = Master.new(:name => "wisdom-less") # wisdom is required to be a Master
    assert_not_valid master
    disciple = Disciple.new(:name => "valid", :master => master)
    assert_not_valid disciple
    assert_equal "is invalid", disciple.errors.on(:master)
  end


  # to see what happens for multiple belongs_to associations
  #test "multiple owners" do
  #  # Given some class with 2 belongs_to associations
  #  class SomeTableWithTwoForeignKeys < ActiveRecord::Base
  #    belongs_to :foo, :bar
  #    validates_belongs_to :foo, :bar
  #  end
  #
  #  # Then, after it has been declared, 2 private validation methods have been defined
  #  assert SomeTableWithTwoForeignKeys.private_method_defined?(:validate_belongs_to_for_foo)
  #  assert SomeTableWithTwoForeignKeys.private_method_defined?(:validate_belongs_to_for_bar)
  #end

  # the following test shows how to mock the master
  # even though in real life, disciples should not mock their master ;-)
  test "disciple can memorize some wisdom from master" do
    master = masters(:yoda)
    disciple = Disciple.new(:name => "novice", :master => master)

    wisdom = "If you find yourself in a hole, stop digging."
    master.expects(:answer).with("What should I learn today?").returns(wisdom)
    # we can check that the disciple is memorizing the wisdom too, however this might be seen
    # as testing the implementation
    disciple.expects(:memorize).with(wisdom)

    disciple.learn
  end
end
