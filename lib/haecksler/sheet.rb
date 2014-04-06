module Haecksler
  class Sheet
    include Enumerable

    attr_reader :row

    DEFAULT_OPTIONS={ header: false, footer: false, header_check: proc{ false }, footer_check: proc{ false } }

    def initialize(input, options={})
      options = DEFAULT_OPTIONS.merge(options)
      @header = options[:header]
      @footer = options[:footer]
      @row    = options[:row]
      @input  = input
      @header_check = options[:header_check]
      @footer_check = options[:footer_check]
    end

    def each
      @input.lazy.each do |input|
        if @header_check.call(input)
          yield @header.parse(input.chomp)
        elsif @footer_check.call(input)
          yield @footer.parse(input.chomp)
        else
          yield @row.parse(input.chomp)
        end
      end
    end

  end
end