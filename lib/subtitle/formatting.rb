# Supported formatting options are:
#
# - Bold
# - Italic
# - Underline
# - Color
# - Font name
# - Font size

class Subtitle
  class Formatting
    attr_reader :section #, :color, :font_name, :font_size
    
    # Bit fields for the binary styling options
    
    #BOLD      = 0x01
    #ITALIC    = 0x02
    #UNDERLINE = 0x04
    
    
    # Initialize
    #
    # Accept the various styling options as named arguments.
    # Using apply to the scope of the formatting can be 
    # controlled as follows:
    # - nil applies to the entire line
    # - 0, 1, ... applies to the first, second and so on section of text 
    #   separated by new-line characters
    # - 0..n applies to characters 0 to n
    
    def initialize section
                   # bold: false, 
                   # italic: false,
                   # underline: false,
                   # color: nil,
                   # font_name: nil,
                   # font_size: nil
      
      # Make sure apply_to is of the correct type
      unless Range === section
        raise TypeError, 
            "Unknown formatting section: #{section.inspect}"
      end
      
      @section    = section
      @formatting = formatting
            
      # @style     = (bold ?      BOLD      : 0) | 
      #              (italic ?    ITALIC    : 0) | 
      #              (underline ? UNDERLINE : 0)
      # 
      # @color     = color
      # @font_name = font_name
      # @font_size = font_size
    end
    
    
    def apply formatting
      @formatting.merge! formatting
      self
    end
    
    
    # Bold?
    #
    # Returns true if the font weight is bold.
    
    def bold?
      @formatting[:bold]
    end
    
    
    # Italic?
    #
    # Returns true if the font style is italic.
    
    def italic?
      @formatting[:italic]
    end
    
    
    # Underline?
    #
    # Returns true if the text is underlined.
    
    def underline?
      @formatting[:underline]
    end
    
    
    def color
      @formatting[:color]
    end
    
    def font_name
      @formatting[:font_name]
    end
    
    def font_size
      @formatting[:font_size]
    end
  end
end