require 'spec_helper'

module Haecksler
  describe Row do
    it "should initialize with empty columns" do
      expect(subject.columns).to have(0).things
    end

    it "should receive more columns" do
      subject << Column.new(name: "Name", size: 10)
      expect(subject.columns).to have(1).thing
      subject << Column.new(name: "Id", size: 2)
    end

    it "should parse a row" do
      subject << Column.new(name: "Name", size: 10)
      subject << Column.new(name: "Id",   size: 2)

      parsed_result = subject.parse("Frank     AB")

      expect(parsed_result).to have(2).things

      expect(parsed_result.first.value).to eq "Frank"
      expect(parsed_result.last.value).to eq "AB"
    end

    it "should parse a row with UTF" do
      subject << Column.new(name: "Name", size: 10)
      subject << Column.new(name: "Id",   size: 2)

      parsed_result = subject.parse("Fränk     €B")

      expect(parsed_result).to have(2).things

      expect(parsed_result.first.value).to eq "Fränk"
      expect(parsed_result.last.value).to eq "€B"

    end

  end
end