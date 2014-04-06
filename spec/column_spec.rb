require 'spec_helper'

module Haecksler
  describe Column do
    subject do
      Column.new(name: "First Name", size: 10, type: :string )
    end
    it "should require all options to be set" do
      expect(subject).to be_a Column
    end

    it "should parse a column" do
      parsed = subject.parse("Frank")
      expect(parsed).to be_a ParsedColumn
      expect(parsed.name).to eq("First Name")
      expect(parsed.value).to eq "Frank"
    end
  end
end
