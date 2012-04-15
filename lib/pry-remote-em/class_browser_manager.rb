class ClassBrowserManager
  class << self
    def module_info_for(mod)
      method_hash_for(mod).merge(module_hash_for(mod))
    end

    def method_source_for(meth_name)
      Pry::Method.from_str(meth_name)
    end

    def module_source_for(mod_name)
      Pry::WrappedModule.from_str(mod_name)
    end

    private
    def method_hash_for(mod)
      {
        :instance_methods => mod.instance_methods(false),
        :class_methods => mod.methods(false)
      }
    end

    def module_hash_for(mod)
      k = mod.constants(false).each_with_object({}) do |c, h|
        if (o = mod.const_get(c)).is_a?(Module) then
          begin
            h[c] = o.constants(false).any? { |c| o.const_get(c).is_a? Module }
          rescue
            next
          end
        end
      end

      { :modules => k }
    end
  end
end
