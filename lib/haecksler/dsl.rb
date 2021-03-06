module Haecksler

  def self.chop(input)
    dsl = Dsl.new.chop(input)
    yield dsl
    dsl.parse!
  end

  class Dsl

    def chop(input)
      @input = input
      @row = Row.new
      @header_check = proc { false }
      @header = false
      @footer_check = proc { false }
      @footer = false
      self
    end

    def header_row
      @header ||= HeaderRow.new
    end

    def footer_row
      @footer ||= FooterRow.new
    end

    def column(name, size, type=:string, date_format=nil)
      @row << _column(name, size, type, date_format)
    end

    def skip(size)
      l = @row.columns.length
      @row << _column("___skip#{l}", size, :nil, nil)
    end

    def header_trap(&proc)
      @header_check = proc
    end

    def footer_trap(&proc)
      @footer_check = proc
    end

    def header(name, size, type=:string, date_format=nil)
      header_row << _column(name, size, type, date_format)
    end

    def footer(name, size, type=:string, date_format=nil)
      footer_row << _column(name, size, type, date_format)
    end

    def parse!
      Sheet.new(@input, {
        row: @row,
        header_check: @header_check,
        header: header_row,
        footer_check: @footer_check,
        footer: footer_row}
      )
    end

    private
    def _column(name, size, type, date_format)
      Column.new({name: name, size: size, type: type, date_format: date_format})
    end



  end

end