require 'spec_helper'

module Haecksler
  describe Row do
    it "should initialize with empty columns" do
      expect(subject.columns).to have(0).things
    end

    it "should not be header or footer" do
      expect(subject).not_to be_header
      expect(subject).not_to be_footer
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

      expect(parsed_result.columns).to have(2).things

      expect(parsed_result.columns.first.value).to eq "Frank"
      expect(parsed_result.columns.last.value).to eq "AB"
    end

    it "should parse a row with UTF" do
      subject << Column.new(name: "Name", size: 10)
      subject << Column.new(name: "Id",   size: 2)

      parsed_result = subject.parse("Fränk     €B")

      expect(parsed_result.columns).to have(2).things

      expect(parsed_result.columns.first.value).to eq "Fränk"
      expect(parsed_result.columns.last.value).to eq "€B"

    end

    it "should have Hash like access" do
      subject << Column.new(name: "Name", size: 3)
      parsed_result = subject.parse("ABC")
      expect(parsed_result["Name"]).to eq("ABC")
    end

    it "should return nil for unknown key" do
      subject << Column.new(name: "Name", size: 3)
      parsed_result = subject.parse("ABC")
      expect(parsed_result["Unknown"]).to be_nil
    end

  end

  describe HeaderRow do
    it "should behave as header" do
      expect(subject).to be_header
      expect(subject).not_to be_footer
    end
  end

  describe FooterRow do
    it "should behave as footer" do
      expect(subject).not_to be_header
      expect(subject).to be_footer
    end
  end
end