module Haecksler
  class Row
    attr_reader :columns

    def initialize(columns = [])
      @columns = columns
    end

    def <<(column)
      @columns << column
    end
  end
end