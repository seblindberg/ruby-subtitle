class Subtitle
  module LineSet
    class Item
      
      # Initialize
      #
      # Create a new item, either before, after or both before and after other 
      # items. If no items are given a new complete LineSet will be created with 
      # this item in it. A complete set consists of a First item, a number of 
      # Items and a Last item.
      
      def initialize before: nil, after: nil
        if before && after
          # Ignore the current prev and next of the given 
          # items and insert the new one between them
          after.next = self
          self.next  = before
        elsif before
          # Put this item before the one given
          before.previous!.next = self
          self.next  = before
        elsif after
          # Put this item after the one given
          self.next  = after.next!
          after.next = self
        else
          # Create support items on either side, making
          # this item a complete set
          @prev = First.new self
          @next = Last.new  self
        end
      end
      
      
      # First Item?
      #
      # Returns false since this is never the first item in the set.
      
      def first_item?
        false
      end
      
      
      # Last Item?
      #
      # Returns false since this is never the last item in the set.
      
      def last_item?
        false
      end
      
      
      # Next
      #
      # Returns the next item in the set. Raises a StopIteration if the next 
      # item is the last.
      
      def next
        raise StopIteration if @next.last_item?
        @next
      end
      
      
      # Next (unsafe)
      #
      # Always returns the next item in the set, without raising any exception.
      
      def next!
        @next
      end
      
      
      # Next =
      #
      # Set the next item. By convention this also sets the previous item to 
      # self for the next item. 
      
      protected def next= item
        @next         = item
        item.previous = self
      end
      
      
      # Previous
      #
      # Returns the previous item in the set. Raises a StopIteration if the 
      # previous item is the first.
      
      def previous
        raise StopIteration if @prev.first_item?
        @prev
      end
      
      
      # Previous (unsafe)
      #
      # Always returns the previous item in the set, without raising any 
      # exception.
      
      def previous!
        @prev
      end
      
      
      # Previous =
      #
      # Set the previous item. This method should rarely be called directly, 
      # since calling #next= does that automatically.
      
      protected def previous= item
        @prev = item
      end
      
      
      # First Line
      #
      # Create a virtual subset where this line is the first one.
      
      protected def first_line
        @first_line ||= LineSet::First.new self
      end
      
      
      # First Line
      #
      # Create a virtual subset where this line is the last one. 
      
      protected def last_line
        @last_line  ||= LineSet::Last.new self
      end
      
      
      # Delete
      #
      # Remove an item from the set.
      
      def delete
        @prev.next = @next
      end
    end
  end
end