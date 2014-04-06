require 'spec_helper'

module Haecksler
  describe Sheet do
    before(:each) do
      @data = [
        "01Frank     20080305",
        "02Sam       20091205"
      ]
      @row = Row.new
      @row << Column.new(name: "Id", size: 2, type: :integer)
      @row << Column.new(name: "Name", size: 10)
      @row << Column.new(name: "Date", size: 8, type: :date)
    end

    it "should parse some array" do
      expect(Sheet.new(@data, row: @row)).to have(2).things
    end

    it "should parse with header" do
      @data = ["HEADER1"] + @data
      header_row = Row.new
      header_row << Column.new(name: "f1", size: 6)
      header_row << Column.new(name: "f2", size: 1, type: :integer)

      s = Sheet.new(@data, row: @row, header: header_row, header_check: proc{|line| line =~ /^HEADER/ })

      expect(s).to be_an Enumerable
      expect(s).to have(3).things
    end

    describe "with a File" do

      it "should process file without header" do

        File.open(File.expand_path("../simple.txt",__FILE__)) do |f|
          s = Sheet.new(f, row: @row)
          expect(s).to have(2).things
        end
      end

    end
  end
end