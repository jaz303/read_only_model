require 'test/unit'

require 'rubygems'
require 'activerecord'

require File.dirname(__FILE__) + '/../init.rb'

ActiveRecord::Base.send(:establish_connection, :adapter => 'sqlite3',
                                               :database => File.dirname(__FILE__) + '/../tmp/test.sqlite')

connection = ActiveRecord::Base.connection
connection.execute("DELETE FROM test_models")

FIXTURE = {
  1 => { :name => "Jon", :number => 5 }.freeze,
  2 => { :name => "Bob", :number => 9 }.freeze,
  3 => { :name => "Tre", :number => 3 }.freeze
}.freeze

FIXTURE.each { |id,f| connection.execute("INSERT INTO test_models (id, name, number) VALUES (#{id}, '#{f[:name]}', #{f[:number]})") }

class TestModel < ActiveRecord::Base
  read_only_model
end

class ReadOnlyModelTest < Test::Unit::TestCase
  
  def setup
    @o = TestModel.new(params)
  end
  
  def test_test_model_with_params_is_valid
    assert TestModel.new(params).valid?
  end
  
  def test_create
    assert_read_only { TestModel.create(params) }
  end
  
  def test_decrement_counter
    assert_read_only { TestModel.decrement_counter('number', 1) }
  end
  
  def test_delete
    assert_read_only { TestModel.delete(1) }
  end
  
  def test_delete_all
    assert_read_only { TestModel.delete_all }
  end
  
  def test_destroy
    assert_read_only { TestModel.destroy(1) }
  end
  
  def test_destroy_all
    assert_read_only { TestModel.destroy_all }
  end
  
  def test_increment_counter
    assert_read_only { TestModel.increment_counter('number', 1) }
  end
  
  def test_update
    assert_read_only { TestModel.update(1, :name => 'Ron') }
  end
  
  def test_update_all
    assert_read_only { TestModel.update_all('number = 0') }
  end
  
  #
  # Instance
  
  def test_create
    assert_read_only { @o.send(:create) }
  end
  
  def test_update
    assert_read_only { first.send(:update) }
  end
  
  def test_decrement!
    assert_read_only { first.send(:decrement!, :number) }
  end
  
  def test_destroy
    assert_read_only { first.destroy }
  end
  
  def test_increment!
    assert_read_only { first.send(:increment!, :number) }
  end

  def test_save_new_record
    assert_read_only { @o.save }
  end
  
  def test_save_existing_record
    assert_read_only { first.save }
  end
  
  def test_save!
    assert_read_only { @o.save! }
  end
  
  def test_toggle!
    assert_read_only { first.toggle!(:number) }
  end
  
  def test_update_attribute
    assert_read_only { first.update_attribute(:name, 'Jason') }
  end
  
  def test_update_attributes
    assert_read_only { first.update_attributes(:name => 'Jason', :number => 6) }
  end
  
  def test_update_attributes!
    assert_read_only { first.update_attributes!(:name => 'Jason', :number => 6) }
  end
  
  private
  
  def first
    TestModel.find(:first)
  end
  
  def params
    { :name => "Terry", :number => 5 }
  end
  
  def assert_read_only
    
    assert_raises(ActiveRecord::ReadOnlyModel) { yield }
    
    all = TestModel.find(:all)
    assert_equal FIXTURE.size, all.size
    
    all.each do |tm|
      assert_equal FIXTURE[tm.id][:name], tm.name
      assert_equal FIXTURE[tm.id][:number], tm.number
    end
    
  end
  
end
