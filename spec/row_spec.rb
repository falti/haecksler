require 'spec_helper'

module Haecksler
  describe Row do
    it "should initialize with empty columns" do
      row = Row.new
      expect(row.columns).to have(0).things
    end
  end
end