# Formatting
#
# The role of the formatting object is just to provide a mutable collection of 
# supported formatting options. The object has no knowledge of what the styling 
# applies to.
#
# Supported formatting options are:
# - Bold
# - Italic
# - Underline
# - Color
# - Font name
# - Font size
#
# Things left to do:
# - Add position as a formating option
# - Introduce some form of validation of the styling? Or make it completely 
#   dynamic
#

class Subtitle
  class Formatting
        
    # Initialize
    #
    # Accept a hash of initial formatting options
    
    def initialize formatting = {}
      @formatting = formatting
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