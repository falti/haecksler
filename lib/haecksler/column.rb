require 'delegate'
require 'date'

module Haecksler

  class TypeError
    attr_reader :value, :type

    def initialize(value, column)
      @value = value
      @type = column.type
    end

    def ==(another_type_error)
      self.value == another_type_error.value && self.type == another_type_error.type
    end

    def to_s
      "Could not parse '#{value}' to '#{type}"
    end

  end

  class ParsedColumn < SimpleDelegator
    attr_accessor :value
  end

  class Column
    attr_reader :name, :size, :type, :date_format

    DEFAULT_OPTIONS={type: :string, date_format: nil}

    def initialize(options = {type: :string})
      options = DEFAULT_OPTIONS.merge(options)
      @name = options[:name]
      @size = options[:size]
      @type = options[:type]
      @date_format = options[:date_format]
    end

    def parse(string_value)
      parsed = ParsedColumn.new(self)

      parsed.value = begin
        case type
        when :nil
          nil
        when :string
          String(string_value).rstrip
        when :integer
          Integer(string_value)
        when :float
          Float(string_value)
        when :date
          parse_date(Date, string_value)
        when :datetime
          parse_date(DateTime, string_value)
        else
          nil
        end
      rescue
        TypeError.new(string_value, self)
      end

      parsed
    end

    def parse_date(clazz, string_value)
      if date_format.nil?
        clazz.parse(string_value)
      else
        clazz.strptime(string_value, date_format)
      end
    end
  end
end