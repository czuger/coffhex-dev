# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

map = null
movement_graph = null
last_selected_pawn = null

print_mouse_info = () ->
  $('#board').mousemove (event) ->

    [ hex, hex_info ] = map.get_current_hex(event)

    html = ''
    for info in hex_info
      html += "<div>#{info}</div>"

    $('#hex_info').html(html)


on_pawn_click = (event, pawn) ->
  [ hex, _ ] = map.get_current_hex(event)

  result = DijkstraMovements.calc( map, hex, parseInt( pawn.attr( 'mov' ) ) )
  last_selected_pawn = pawn

  for key in result
    [q, r] = key.split( '_' )

    map.pawn_module.create_phantom( pawn, parseInt(q), parseInt(r) )

  manage_movement()
  null


manage_movement = () ->
  $('.pawn_phantom').click ->
    $(this).removeClass('pawn_phantom')
    $(this).addClass('pawn')

    last_selected_pawn.remove()

    $('.pawn_phantom').remove()

    $(this).click (event) ->
      on_pawn_click(event, $(this))


put_pawn_on_map = ( pawn, q, r ) ->

  new_object = map.pawn_module.put_on_map( pawn, q, r )

  new_object.click (event) ->
    on_pawn_click(event, $(this))


load = () ->
  print_mouse_info()

  map = new Map()

  put_pawn_on_map( $('#orf_infantery_1'), 27, 8 )
  put_pawn_on_map( $('#orf_artillery_1'), 30, 1 )
  put_pawn_on_map( $('#orf_cavalry_1'), 28, 5 )


$ ->
  if window.location.pathname == '/' || window.location.pathname == '/test/show'
    load()