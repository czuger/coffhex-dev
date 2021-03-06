# CAUTION : deprecated, use update_json_map instead

@map = AxialGrid.new

# Load it with
@map.read_ascii_file_flat_topped_odd( 'data/map.txt' )
orf_border = JSON.parse( File.open( 'data/orf_border.json', 'r' ).read )

@map.each do |hex|
  hex.data[ :side ] = 'wulf'
end

orf_border.each do |b|
  # p b
  hex = @map.cget( b['q'], b['r'] )
  hex.data[:side] = 'orf' if hex
end

File.open( 'data/map.json', 'w' ) do |f|
  f.write( @map.to_json )
end

