# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe InvaderChecker do
  describe '#initialize' do
    it 'creates a checker with default threshold' do
      checker = InvaderChecker.new
      # Default threshold is 1.0 
      expect(checker).to be_a(InvaderChecker)
    end

    it 'creates a checker with custom threshold' do
      checker = InvaderChecker.new(threshold: 0.9)
      expect(checker).to be_a(InvaderChecker)
    end
  end

  describe '#find_invader' do
    let(:checker) { InvaderChecker.new(threshold: 0.8) }

    it 'finds an invader that matches exactly' do
      invader = <<~PATTERN
        oo
        oo
      PATTERN

      radar = <<~RADAR
        oo--
        oo--
        ----
      RADAR

      matches = checker.find_invader(invader, radar)
      expect(matches).to include({ row: 0, col: 0 })
    end

    it 'works with uppercase and lowercase letters' do
      invader = <<~PATTERN
        oo
        oo
      PATTERN

      radar = <<~RADAR
        OO--
        OO--
        ----
      RADAR

      matches = checker.find_invader(invader, radar)
      expect(matches).to include({ row: 0, col: 0 })
    end

    it 'uses threshold to find partial matches' do
      # This invader has 75% match
      invader = <<~PATTERN
        oo
        oo
      PATTERN

      radar = <<~RADAR
        oo--
        o---
        ----
      RADAR

      # With 0.75 threshold, it should find a match
      checker_low = InvaderChecker.new(threshold: 0.75)
      matches = checker_low.find_invader(invader, radar)
      expect(matches).to include({ row: 0, col: 0 })

      # With 0.8 threshold, it should NOT find a match (75% < 80%)
      matches_high = checker.find_invader(invader, radar)
      expect(matches_high).to be_empty
    end

    it 'finds multiple matches' do
      invader = <<~PATTERN
        oo
        oo
      PATTERN

      radar = <<~RADAR
        oo--oo
        oo--oo
        ------
      RADAR

      matches = checker.find_invader(invader, radar)
      expect(matches.length).to eq(2)
      expect(matches).to include({ row: 0, col: 0 })
      expect(matches).to include({ row: 0, col: 4 })
    end

    it 'returns empty array when no matches found' do
      invader = <<~PATTERN
        oo
        oo
      PATTERN

      radar = <<~RADAR
        ----
        ----
        ----
      RADAR

      matches = checker.find_invader(invader, radar)
      expect(matches).to be_empty
    end
  end
end
