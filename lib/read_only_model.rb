module ActiveRecord
  class ReadOnlyModel < ActiveRecordError #:nodoc:
  end
end

module OHOA
  module Rails
    module ReadOnlyModel
  
      def self.included(base)
        base.extend(ActMethods)
      end
  
      module ActMethods
        def read_only_model
          self.extend(ClassMethods)
          self.send(:include, OHOA::Rails::ReadOnlyModel::InstanceMethods)
        end
      end
  
      module ClassMethods
        def delete_all(conditions = nil)
          raise ActiveRecord::ReadOnlyModel
        end
    
        def update_all(updates, conditions = nil)
          raise ActiveRecord::ReadOnlyModel
        end
      end
  
      module InstanceMethods
        def destroy
          raise ActiveRecord::ReadOnlyModel
        end
    
        private
    
        def create
          raise ActiveRecord::ReadOnlyModel
        end
    
        def update
          raise ActiveRecord::ReadOnlyModel
        end
      end
  
    end
  end
end
