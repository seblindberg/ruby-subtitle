class Subtitle
  module LineSet
    class Last < Item
      
      # Initialize
      #
      # 
      
      def initialize prev_item
        @prev = prev_item
      end
      
      
      # Last Item?
      #
      #
      
      def last_item?
        true
      end
      
      
      # Next (unsafe)
      #
      #
      
      def next!
        self
      end
      
      
      # Next =
      #
      #
      
      protected def next= _
        raise RuntimeError, 
            'Last items can not have anything come after them'
      end
      
    end
  end
end