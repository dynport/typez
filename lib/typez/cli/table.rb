module Typez
  module CLI
    class Table
      def <<(arr)
        rows << arr
      end

      def rows
        @rows ||= []
      end

      def lengths
        out = Hash.new(0)
        rows.each do |row|
          row.each_with_index do |row, i|
            out[i] = [out[i], row.to_s.length].max
          end
        end
        out
      end

      def to_s(attributes = {})
        padding = attributes[:padding] || 1
        rows.map do |row|
          row.inject([]) do |arr, col|
            arr << "%0*s" % [lengths[arr.length] + padding, col]
            arr
          end.join("\t")
        end.join("\n")
      end
    end
  end
end
