# This class represents a grid of hexagons stored in an axial coordinate system.
#
# Please read http://www.redblobgames.com/grids/hexagons/#coordinates to understand what an axial coordinates system is.
#
# @author Cédric ZUGER
#

class @AxialGrid

  directions = [ [0,-1], [1,-1], [1,0], [0,1], [-1,+1], [-1,0] ]

  # Create an axial hexagon grid
  #
  # @param hex_ray [Integer] the size of an hexagon. Please read : http://www.redblobgames.com/grids/hexagons/#basics for information about the size of an hexagon
  constructor: ( @hex_ray ) ->
    @hexes={}

  # Create an hexagon at a given position (q, r)
  #
  # @param q [Integer] the q coordinate of the hexagon
  # @param r [Integer] the r coordinate of the hexagon
  # @param color [String] a colorstring that can be used by ImageMagic
  # @param border [Boolean] is the hex on the border of the screen (not fully draw)
  # @param data [Unknown] some data associated with the hexagone. Everything you want, it is up to you.
  #
  # @return [AxialHex] an hexagon
  #
  cset: ( q, r, data ) ->
    @hexes[ [ q, r ] ] = new AxialHex( q, r, data )

  # Get the hexagon at a given position (q, r)
  #
  # @param q [Integer] the q coordinate of the hexagon
  # @param r [Integer] the r coordinate of the hexagon
  #
  # @return [AxialHex] the hexagon at the requested position. nil if nothing
  #
  cget: ( q, r ) ->
    @hexes[ [ q, r ] ]

  # Remove an hexagon from a grid
  #
  # @param q [Integer] the q coordinate of the hexagon
  # @param r [Integer] the r coordinate of the hexagon
  cclear: ( q, r ) ->
    delete @hexes[ [ q, r ] ]

  # Insert an hexagon into the grid
  #
  # @param hex [AxialHex] the hexagon you want to add into the grid
  #
  # @return [AxialHex] the hexagon you inserted
  #
  hset: ( hex ) ->
    @hexes[ [ hex.q, hex.r ] ] = hex

  # Get the hexagon
  #
  # @param hex [AxialHex] the hexagon you want to get from the grid
  #
  # @return [AxialHex] the hexagon at the requested position. nil if nothing
  #
  hget: ( hex ) ->
    @hexes[ [ hex.q, hex.r ] ]

  # Remove an hexagon from a grid
  #
  # @param hex [AxialHex] the hexagon you want to add into the grid
  #
  # @return [AxialHex] the hexagon you inserted
  #
  hclear: ( hex ) ->
    delete @hexes[ [ hex.q, hex.r ] ]

  # Return the grid as a json_array object
  #
  # @return [Array] the grid as a hash object
  from_json: ( json_str ) ->
    js = JSON.parse( json_str )
#    console.log( js )
    for je in js
      je.data.color = je.data.color.toLowerCase()
      this.cset( je['q'], je['r'], je.data )

#    console.log( @hexes )
    null
#    console.log( @hexes )
#    console.log( @hexes[[0,0]] )

  pixel_to_hex_flat_topped: (x, y) ->

    q = x * 2/3 / @hex_ray
    r = (-x / 3 + Math.sqrt(3)/3 * y) / @hex_ray

#    console.log( 'checking for q = ' + Math.round( q ) + 'r = ' + Math.round( r ) )
    return @cget( Math.round( q ), Math.round( r ) )

  hex_to_pixel_flat_topped: ( hex ) ->
    # Caution, q
    x = @hex_ray * 3.0/2.0 * (hex.q+0.5)
    y = @hex_ray * Math.sqrt(3) * (hex.r + 0.5 + (hex.q/2.0))
    [ Math.round( x ), Math.round( y ) ]

  h_surrounding_hexes: ( hex ) ->
#    console.log( "hexes = ", @hexes )
    hexes_array = []
    for direction in directions
      s_hex = @cget( hex.q+direction[0], hex.r+direction[1] )
      if s_hex
        hexes_array.push( s_hex )

    hexes_array

  hexes_at_range: ( hex, range ) ->
    results = []
    center = hex.to_cube()
    for dx in [-range .. range]
      for dy in [ Math.max( -range, -dx-range ) .. Math.min( range, -dx+range ) ]
        dz = -dx-dy
        results.push( center.add( new CubeHex(dx, dy, dz)).to_axial() )

    results