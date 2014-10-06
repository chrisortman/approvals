module Approvals
  module Namers
    class RSpec13Namer

      attr_reader :name
      def initialize(example)
        @name = normalize example.description
      end

      def normalize(string)
        string.strip.squeeze(" ").gsub(/[\ :-]+/, '_').gsub(/[\W]/, '').downcase
      end

      def output_dir
        unless @output_dir
          @output_dir ||= 'spec/fixtures/approvals/'
        end
        @output_dir
      end

    end
  end
end
