class Subtitle
  module Formatable    
    # Format
    #
    # Accept the various styling options as named arguments.
    # Using apply to the scope of the formatting can be 
    # controlled as follows:
    # - nil applies to the entire line
    # - 0, 1, ... applies to the first, second and so on section of text 
    #   separated by new-line characters
    # - 0..n applies to the characters at index 0 through n
    
    def format section = nil, fmt = {}
      
      if Hash === section
        section, fmt = nil, section
      end
      
      # Convert supported section types to character ranges
      section = case section
      when NilClass
        0...@text.length
      
      when Range
        if section.begin < 0 || section.end >= @text.length
          raise RangeError, 
              'The range covers more than the text'
        end
        
        section
        
      when Fixnum
        offsets = @text.split("\n").map(&:length)
        
        if section >= offsets.count
          raise RangeError, 
              "The line does not contain #{section} sections"
        end
        
        from    = offsets[0...section].reduce(0) { |s,o| s + o + 1 }
        to      = from + offsets[section] - 1
        
        from..to
      
      else
        raise TypeError, 
            "Unknown formatting section: #{section.inspect}"
      end
      
      # Apply the formatting to the selected section of the
      # line text
      formatting[section].apply fmt
    end
  end
end