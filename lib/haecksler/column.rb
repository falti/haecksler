require 'delegate'

module Haecksler

  class TypeError
    attr_reader :value, :type

    def initialize(value, column)
      @value = value
      @type = column.type
    end

    def to_s
      "Could not parse '#{value}' to '#{type}"
    end

  end

  class ParsedColumn < SimpleDelegator
    attr_accessor :value
  end

  class Column
    attr_reader :name, :size, :type

    DEFAULT_OPTIONS={type: :string}

    def initialize(options = {type: :string})
      options = DEFAULT_OPTIONS.merge(options)
      @name = options[:name]
      @size = options[:size]
      @type = options[:type]
    end

    def parse(string_value)
      parsed = ParsedColumn.new(self)

      parsed.value = begin
        case type
        when :string
          String(string_value).rstrip
        when :integer
          Integer(string_value)
        when :float
          Float(string_value)
        else
          nil
        end
      rescue
        TypeError.new(string_value, self)
      end

      parsed
    end
  end
end