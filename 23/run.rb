#!/usr/bin/env ruby

Node = Struct.new( :value, :next, :prev_by_value ) do
   # next points to next value clockwise
   # prev_by_value points to the node with a value 1 less than this
end

# make circular linked list
# returns [ head pointer, map of position -> node ]
def make_list( values )
  
  positions = {}
  head, current = nil, nil

  values.each do |v|
    n = Node.new( v )
    positions[v] = n
 
    if head == nil
      head = n
    end
    if current == nil
      current = n
    else
      current.next = n
      current = n
      n.next = head
    end
   end

  # now loop the list and assign each node's prev_by_value pointer.  we could 
  # prob do this inline above, but, doing it lazy for now
  iter = head
  while iter.next != head
    prev_value = ( iter.value > 1 ? iter.value - 1 : values.length )
    iter.prev_by_value = positions[iter.value - 1]
    iter = iter.next
  end

 [ head, positions ]
end

# run n iterations of the game 
def run( current, positions, iterations, num_values )
    iterations.times do 
        slice_start = current.next
        current.next = current.next.next.next.next
        destination = nil
        backoff = 1
    
        while ! destination 
            search_for_label = current.value - backoff
            if search_for_label < 1
              search_for_label += num_values
            end            
            destination = positions[search_for_label]
            if destination.value == slice_start.value ||
               destination.value == slice_start.next.value ||
               destination.value == slice_start.next.next.value 
                 destination = nil
                 backoff += 1
            end
        end
    
        after_slice = destination.next
        destination.next = slice_start
        slice_start.next.next.next = after_slice
        current = current.next
    end
end

input = '326519478'.chars.map(&:to_i)
head, positions = make_list( input )
run( head, positions, iterations=100, num_values=9 )
after_one = positions[1].next
part1 = ""
8.times do
    part1 << ( after_one.value.to_s )
    after_one = after_one.next
end
puts "part 1: #{part1}"

head, positions = make_list( input + (10..1_000_000).to_a )
run( head, positions, iterations=10_000_000, num_values=1_000_000 )
after_one = positions[1].next
puts "part 2: #{after_one.value * after_one.next.value}"
