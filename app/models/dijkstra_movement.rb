# require 'rhex'
# require 'algorithms'

class DijkstraMovement

  def self.hex_key( hex )
    [ hex.q, hex.r ].join( '_')
  end

  def self.movement_key( from, to )
    [ from.q, from.r, to.q, to.r ].join( '_')
  end

  # Call with : find( map, movement_graph, [], [ current_hex.q, current_hex.r ], current_hex, n )
  def self.find( map, movement_graph, current_hex, max_distance )

    goal = AxialHex.new( -1, -1 )

    frontier = Containers::PriorityQueue.new()
    frontier.push(current_hex, 0)
    frontier_history = []
    came_from = {}
    cost_so_far = {}
    came_from[ hex_key(current_hex) ] = nil
    cost_so_far[ hex_key(current_hex) ] = 0

    while not frontier.empty?
      current = frontier.pop()
      frontier_history << hex_key( current )

      break if current == goal

      map.h_surrounding_hexes( current ).each do |n|

        new_cost = cost_so_far[ hex_key(current) ] + movement_graph[ movement_key( current, n ) ]
        break if new_cost > max_distance

        if not cost_so_far[ hex_key( n ) ] or new_cost < cost_so_far[ hex_key( n ) ]

          cost_so_far[ hex_key( n ) ]  = new_cost
          priority = new_cost
          frontier.push( n, priority )
          came_from[ hex_key( n ) ] = current
        end
      end
    end

    frontier_history

  end

end