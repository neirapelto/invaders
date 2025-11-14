# frozen_string_literal: true

require_relative "invaders/version"

class InvaderChecker
  def initialize(threshold: 1)
    @threshold = threshold
  end

  # This method looks for the invader in the radar
  def find_invader(invader, radar)
    # Convert multi-line strings to arrays of strings (one per line)
    invader_lines = invader.strip.split("\n")
    radar_lines = radar.strip.split("\n")
    
    # Count invader and radar rows and columns
    invader_rows = invader_lines.length
    invader_cols = invader_lines[0].length
    radar_rows = radar_lines.length
    radar_cols = radar_lines[0].length
    
    # This array will store the positions where the invader was found
    matches = []
    
    # Go through every possible row where the invader could fit
    (0..radar_rows - invader_rows).each do |row|
      # Go through every possible column where the invader could fit
      (0..radar_cols - invader_cols).each do |col|
        # Check if the invader matches at this position
        if matches_at_position?(invader_lines, radar_lines, row, col)
          # If the invader does match at this position, add the position to the matches array
          matches << { row: row, col: col }
        end
      end
    end
    
    # Return the matches array
    matches
  end

  private

  # This method checks if the invader matches at that specific position in the radar
  def matches_at_position?(invader_lines, radar_lines, start_row, start_col)
    # Count how many characters in the invader match the characters in the radar at this position
    # also count how many characters were checked in total
    matches = 0
    total_checks = 0
    
    # Go through each line in the invader
    invader_lines.each_with_index do |invader_line, i|
      # Get the line in the radar that is at the same row as the invader
      radar_line = radar_lines[start_row + i]
      # Go through each character in the invader line 
      # and compare it to the character in the radar line at the same column as the invader
      invader_line.each_char.with_index do |char, j|
        radar_char = radar_line[start_col + j]
        # Count how many characters were checked in total for the percentage calculation
        total_checks += 1
        # Allow case-insensitive matching (o matches O) because there is a case like that in the radar sample
        if char.downcase == radar_char.downcase
          # If the characters match, count the match
          matches += 1
        end
      end
    end
    
    # If no characters were checked, return false
    return false if total_checks == 0
    # Return true if the percentage of matches is greater than or equal to the threshold
    (matches.to_f / total_checks) >= @threshold
  end
end
