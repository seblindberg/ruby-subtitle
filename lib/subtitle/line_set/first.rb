class Subtitle
  module LineSet
    class First < Item
      
      # Initialize
      #
      # If no item following this one is given a new Last item is created.
      
      def initialize next_item = nil
        if next_item
          @next = next_item
        else 
          @next = Last.new self
        end
      end
      
      
      # First Item?
      #
      # Returns true since this is the first item of the set.
      
      def first_item?
        true
      end
      
      
      # Previous (unsafe)
      #
      # 
      
      def previous!
        self
      end
      
      
      # Previous =
      #
      # Dissallow setting any previous item since the first line by definition 
      # must come first.
      
      protected def previous= _
        raise RuntimeError, 
            'First items can not have anything come before them'
      end
    end
  end
end