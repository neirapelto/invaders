# frozen_string_literal: true

require_relative "invaders/version"

class InvaderChecker
  def initialize(threshold: 1)
    @threshold = threshold
  end

  def find_invader(invader, radar)
    # Convert multi-line strings to arrays of strings (one per line)
    invader_lines = invader.strip.split("\n")
    radar_lines = radar.strip.split("\n")
    
    invader_rows = invader_lines.length
    invader_cols = invader_lines[0].length
    radar_rows = radar_lines.length
    radar_cols = radar_lines[0].length
    
    matches = []
    
    (0..radar_rows - invader_rows).each do |row|
      (0..radar_cols - invader_cols).each do |col|
        if matches_at_position?(invader_lines, radar_lines, row, col)
          matches << { row: row, col: col }
        end
      end
    end
    
    matches
  end

  private

  def matches_at_position?(invader_lines, radar_lines, start_row, start_col)
    matches = 0
    total_checks = 0
    
    invader_lines.each_with_index do |invader_line, i|
      radar_line = radar_lines[start_row + i]
      invader_line.each_char.with_index do |char, j|
        radar_char = radar_line[start_col + j]
        total_checks += 1
        # Allow case-insensitive matching (o matches O) because there is a case like that in the radar sample
        if char.downcase == radar_char.downcase
          matches += 1
        end
      end
    end
    
    return false if total_checks == 0
    (matches.to_f / total_checks) >= @threshold
  end
end
