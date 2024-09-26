module Foobara
  module Util
    module_function

    def descendants(klass)
      all = Set.new

      klass.subclasses.each do |subclass|
        all << subclass
        all |= descendants(subclass)
      end

      all
    end

    # WARNING: This approach is known as being slow. Probably better for you class to track its own instances
    # if this is being used for smoething more than debugging.
    def instances(klass)
      ObjectSpace.each_object(klass).to_a
    end

    # Kind of surprising that Ruby doesn't have a built in way to do this.
    def super_method_of(current_instance, from_class, method_name)
      method = current_instance.method(method_name)
      method = method.super_method until method.owner == from_class
      method.super_method
    end

    def super_method_takes_parameters?(current_instance, from_class, method_name)
      super_method_of(current_instance, from_class, method_name).parameters.any?
    end

    def find_constant_through_class_hierarchy(klass, constant)
      if klass.const_defined?(constant)
        klass.const_get(constant)
      else
        unless klass == Object
          find_constant_through_class_hierarchy(constant, klass.superclass)
        end
      end
    end
  end
end
