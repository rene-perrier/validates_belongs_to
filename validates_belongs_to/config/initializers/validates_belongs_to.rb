# Custom validation macro checking that a given belongs_to association
# points to an existing or (new and valid) active record object.
module ActiveRecord
  class Base
    def self.validates_belongs_to(*attributes)
      attributes.each do |attribute|
        validation_method = "validate_belongs_to_for_#{attribute}".to_sym
        send :validate, validation_method
        define_method(validation_method) do
          owner = self.send(attribute)
          if owner
            errors.add(attribute, "is invalid") if (owner.new_record? && !owner.valid?)
          else
            errors.add(attribute, "is invalid or missing")
          end
        end
        send :private, validation_method
      end
    end

  end
end