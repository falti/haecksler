module Haecksler

  class Row
    attr_reader :columns

    def initialize(columns = [])
      @columns = columns
    end

    def <<(column)
      @columns << column
    end

    def [](key)
      begin
        @columns.find{|c| c.name == key }.value
      rescue
        nil
      end
    end

    def parse(input)

      total_number_of_characters = columns.map(&:size).reduce(&:+)
      input = input.slice(0, total_number_of_characters)

      indizes = columns.map(&:size).reduce([0]) do |memo,item|
        memo << (memo.last.to_i + item)
        memo
      end

      slices = input.split(//).each_with_index.slice_before { | element | indizes.include? element[1] }

      parsed_columns = slices.map {|slice| slice.map{|i| i[0]}.join("")}.zip(columns).map do |text, column|
        column.parse(text)
      end

      @columns = parsed_columns

      self
    end

    def header?
      false
    end

    def footer?
      false
    end
  end

  class HeaderRow < Row
    def header?
      true
    end
  end

  class FooterRow < Row
    def footer?
      true
    end
  end

end