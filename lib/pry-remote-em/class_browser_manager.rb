class ClassBrowserManager
  class << self
    def module_info_for(mod_name)
      mod = Pry::WrappedModule.from_str(mod_name)
      module_hash_for(mod)
    end

    def method_source_for(meth_name)
      Pry::Method.from_str(meth_name).source
    end

    def module_source_for(mod_name)
      Pry::WrappedModule.from_str(mod_name).source
    end

    def instance_methods_for(mod)
      all_from_common(mod, :instance_method)
    end

    def methods_for(mod)
      all_from_common(mod, :method)
    end

    def context_data_for(obj)
      obj = Pry::WrappedModule.from_str(obj)

      h = {}

      if obj.is_a?(Module)
        h["instance_methods"] = instance_methods_for(obj)
        h["constants"] = obj.constants(false)
      end

      h["methods"] = methods_for(obj)
      h["instance_variables"] = obj.instance_variables
      h
    end

    private
    def all_from_common(mod, method_type)
      %w(public protected private).map do |visibility|
        safe_send(mod, :"#{visibility}_#{method_type}s", false).select do |method_name|
          if method_type == :method
            safe_send(mod, method_type, method_name).owner == class << mod; self; end
          else
            safe_send(mod, method_type, method_name).owner == mod
          end
        end.map do |method_name|
          Pry::Method.new(safe_send(mod, method_type, method_name), :visibility => visibility.to_sym)
        end
      end.flatten
    end

    def module_hash_for(mod)
      k = mod.constants(false).each_with_object({}) do |c, h|
        if (o = mod.const_get(c)).is_a?(Module) then
          begin
            h[c] = o.constants(false).any? { |c| o.const_get(c).is_a? Module }
          rescue Pry::RescuableException
            next
          end
        end
      end

      { :modules => k }
    end
  end
end
