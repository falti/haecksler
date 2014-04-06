require 'delegate'

module Haecksler

  class ParsedColumn < SimpleDelegator
    attr_accessor :value
  end

  class Column
    attr_reader :name, :size, :type

    def initialize(options = {})
      @name = options[:name]
      @size = options[:size]
      @type = options[:type]
    end

    def parse(string_value)
      parsed = ParsedColumn.new(self)

      parsed.value = case self.type
      when :string
        string_value
      else
        nil
      end
      parsed
    end
  end
end