require 'spec_helper'

module Haecksler
  describe Column do
    describe "a string column" do
      subject do
        Column.new(name: "First Name", size: 10, type: :string )
      end
      it "should require all options to be set" do
        expect(subject).to be_a Column
      end

      it "should parse a string column" do
        parsed = subject.parse("Frank")
        expect(parsed).to be_a ParsedColumn
        expect(parsed.name).to eq("First Name")
        expect(parsed.value).to eq "Frank"
      end

      it "should trim trailing whitespace" do
        expect(subject.parse("Frank     ").value).to eq "Frank"
      end

      it "should keep leading whitespace" do
        expect(subject.parse(" Frank    ").value).to eq " Frank"
      end

    end

    describe "Integer column" do

      subject do
        Column.new(name: "I1", size: 2, type: :integer)
      end

      it "should handle integer column" do
        expect(subject.parse("2 ").value).to eq 2
        expect(subject.parse(" 2").value).to eq 2
        expect(subject.parse("02").value).to eq 2
      end

      it "should yield a TypeError for wrong type column" do
        expect(subject.parse("x ").value).to be_a TypeError
      end

    end

    describe "Float column" do
      subject do
        Column.new(name: "I1", size: 3, type: :float)
      end
      it "should handle double column" do
        expect(subject.parse("2  ").value).to eq 2.0
        expect(subject.parse("2.0").value).to eq 2.0
        expect(subject.parse("02").value).to eq 2.0
      end

      it "should yield a TypeError for wrong type column" do
        expect(subject.parse("x  ").value).to be_a TypeError
      end
    end

    describe "Date column" do
      subject do
        Column.new(name: "I1", size: 8, type: :date)
      end

      it "should handle date column" do
        expect(subject.parse("20130304").value).to eq Date.new(2013,3,4)
      end

      it "should respect date format" do
        c = Column.new(name:"I2", size: 10, type: :date, date_format: '%d.%m.%Y')
        expect(c.parse("03.12.2008").value).to eq Date.new(2008,12,3)
      end
    end

    describe "DateTime column" do
      subject do
        Column.new(name: "I1", size: 8, type: :datetime)
      end

      it "should handle date column" do
        expect(subject.parse("20130304").value).to eq DateTime.new(2013,3,4)
      end

    end

  end
end
