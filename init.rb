require File.dirname(__FILE__) + '/lib/read_only_model'

ActiveRecord::Base.class_eval do
  include OHOA::Rails::ReadOnlyModel
end