module Approvals
  class Filter
    attr_reader :filters

    def initialize(filters)
      @filters = filters
      @placeholder = {}
    end

    def apply hash_or_array
      if @filters.any?
        censored(hash_or_array)
      else
        hash_or_array
      end
    end

    def censored value, key=nil
      case value
      when Array
        value.map { |item| censored(item) }
      when Hash
        Hash[value.map { |k, v| [k, censored(v, k)] }]
      else
        if value.nil?
          nil
        elsif key && placeholder_for(key)
          "<#{placeholder_for(key)}>"
        else
          value
        end
      end
    end

    def placeholder_for key
      return @placeholder[key] if @placeholder.key? key

      debugger;

      applicable_filters = filters.select do |placeholder, pattern|
        filter_applies?(pattern,key)
      end

      applicable_filters = 
        filters.select { |_,pattern| filter_applies?(pattern,key) }

      #Ruby 1.8.7 doesn't give you a Hash back from #select
      @placeholder[key] = Hash[applicable_filters].keys.last
    end

    def filter_applies?(pattern, data_key)
      if data_key.respond_to?(:match)
        pattern && data_key.match(pattern)
      else
        pattern && data_key.to_s.match(pattern)
      end
    end
  end
end
