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
        expect(subject.parse("x ").value).to eq TypeError.new("x ",subject)
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
        expect(subject.parse("x").value).to eq TypeError.new("x",subject)
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

      it "should fail to parse if date format was not followed" do
        c = Column.new(name:"I2", size: 10, type: :date, date_format: '%d.%m.%Y')
        expect(c.parse("2008/03/12").value).to eq TypeError.new("2008/03/12", c)
      end
    end

    describe "DateTime column" do
      subject do
        Column.new(name: "I1", size: 8, type: :datetime)
      end

      it "should handle datetime column" do
        expect(subject.parse("20130304").value).to eq DateTime.new(2013,3,4)
      end

      it "should respect datetime format" do
        c = Column.new(name:"I2", size: 10, type: :datetime, date_format: '%d.%m.%Y')
        expect(c.parse("03.12.2008").value).to eq DateTime.new(2008,12,3)
      end

      it "should fail to parse non-datetime column" do
        expect(subject.parse("xxx").value).to eq TypeError.new("xxx",subject)
      end

    end

    describe "Nil column" do
      subject do
        Column.new(name: "Nil", size: 3, type: :nil)
      end

      it "should handle nil column" do
        expect(subject.parse("XXX").value).to eq nil
      end
    end

    describe TypeError do
      subject do
        column = double("column", :type => :string)
        TypeError.new("x",column)
      end

      it "should give a nice to_s" do
        expect(subject.to_s).to eq "Could not parse 'x' to 'string"
      end
    end

  end
end
