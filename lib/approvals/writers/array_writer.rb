module Approvals
  module Writers
    class ArrayWriter < TextWriter

      def format(data)
        filtered = filter(data).map
        if filtered.respond_to?(:with_index)
          filter(data).map.with_index do |value, i|
            "[#{i.inspect}] #{value.inspect}\n"
          end.join
        else
          i = -1
          s = []
          filtered.each do |value|
            i = i + 1
            s << "[#{i.inspect}] #{value.inspect}\n"
          end
          s.join
        end
      end

      def filter data
        filter = ::Approvals::Filter.new(Approvals.configuration.excluded_json_keys)
        filter.apply(data)
      end
    end
  end
end
