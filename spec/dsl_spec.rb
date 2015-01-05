require "spec_helper"

module Haecksler

  describe Haecksler do

    before(:each) do
      @data = [
        "01Frank     20080305",
        "02Sam       20091205"
      ]
    end

    it "should work without header/footer" do

      result = Haecksler.chop(@data) do |h|
        h.column "Id", 2, :integer
        h.column "Name", 10
        h.column "Date", 8, :date
      end

      expect(result.first["Name"]).to eq "Frank"
    end

    it "should work with header" do

      @data.unshift("HEADER01")
      result = Haecksler.chop(@data) do |h|
        h.header_trap {|header| header =~/^HEADER/ }
        h.header "HName", 6
        h.header "SomeNumber", 2, :integer
        h.column "Id", 2, :integer
        h.column "Name", 10
        h.column "Date", 8, :date
      end
      header = result.first

      expect(header["HName"]).to eq "HEADER"
      expect(header["SomeNumber"]).to eq 1
    end

    it "should work with footer" do
      @data << "FOOTER02"
      result = Haecksler.chop(@data) do |h|
        h.footer_trap {|footer| footer =~/^FOOTER/ }
        h.footer "footer", 6
        h.footer "SomeNumber", 2, :integer
        h.column "Id", 2, :integer
        h.column "Name", 10
        h.column "Date", 8, :date
      end

      footer = result.to_a.last
      expect(footer["footer"]).to eq "FOOTER"
      expect(footer["SomeNumber"]).to eq 2
    end

    it "should work on full sample" do
      file = File.open(File.expand_path("../complete.txt",__FILE__))

      result = Haecksler.chop(file) do |h|

        h.header_trap {|header| header =~/^FILE/ }
        h.header "HName", 4
        h.header "HExtra", 6

        h.column "Id", 2, :integer
        h.column "Name", 10
        h.column "Date", 8, :date

        h.footer_trap {|footer| footer =~/^END/ }
        h.footer "FFooter", 3
        h.footer "FDate", 8, :date
      end.to_a


      expect(result[0]).to be_a HeaderRow
      expect(result[1]).to be_a Row
      expect(result[2]).to be_a Row
      expect(result[3]).to be_a FooterRow


    end

    it "should skip certain values" do
      data_with_skip = [
        "01FrankXXX20080305XXXA",
        "02Sam  XXX20091205XXXB"
      ]
      result = Haecksler.chop(data_with_skip) do |h|
        h.column "Id", 2, :integer
        h.column "Name", 5, :string
        h.skip 3
        h.column "Date", 8, :date
        h.skip 3
        h.column "Letter", 1, :string
      end

      first = result.first
      expect(first["Id"]).to eq 1
      expect(first["Name"]).to eq "Frank"
      expect(first["Date"]).to eq Date.new(2008,3,5)
      expect(first["Letter"]).to eq "A"

    end

    it "should allow to ignore trailing garbage" do
      data = ["Name   SomethingElse   Banana   Idontcare atall whatgoes here"]
      result = Haecksler.chop(data) do |h|
        h.column "Name", 7
        h.skip 16
        h.column "Fruit", 9
      end

      first = result.first
      expect(first["Name"]).to eq "Name"
      expect(first["Fruit"]).to eq "Banana"

    end
  end
end