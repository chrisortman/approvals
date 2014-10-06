module Approvals
  module Namers
    # Can't find a good way to get the context info
    # in RSpec 1.3.2 so this is a brute force approach to just give it the file name
    # :(
    class ExplicitNamer

      attr_reader :name
      def initialize(sub_path,filename)
        @name = normalize example.description
      end

      def normalize(string)
        string.strip.squeeze(" ").gsub(/[\ :-]+/, '_').gsub(/[\W]/, '').downcase
      end

      def output_dir
        unless @output_dir
          @output_dir ||= 'spec/fixtures/approvals/' + sub_path
        end
        @output_dir
      end

    end
  end
end
