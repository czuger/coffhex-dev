# This class represents a pawn on the map.

class @PawnFight

  PAWNS_ATTACK = { 'art': 3, 'cav': 2, 'inf': 5 }
  DEFENCE_TERRAIN_MODIFIER = { 'c': 2, 'b': 3 }
  DEFENCE_TERRAIN_DICE_MODIFIER = { 'f': 2, 'h': 1 }

  # Check if two pawns can attack themselves and return the attack_amount
  @check_attack_value: ( defender, attacker, terrain_map ) ->
    movement_hash = terrain_map.movement_graph
    defender_hex = defender.get_hex()
    attacker_hex = attacker.get_hex()
    dist = defender_hex.distance( attacker_hex )

    if ( attacker.pawn_type == 'cav' || attacker.pawn_type == 'inf' ) && dist == 1
      if movement_hash.cost( defender_hex, attacker_hex ) <= 2
#        console.log( movement_hash.cost( defender_hex, attacker_hex ) )
        return PAWNS_ATTACK[attacker.pawn_type]

    if ( attacker.pawn_type == 'art' ) && dist <= 2
      return PAWNS_ATTACK[attacker.pawn_type]

    return 0

  # Return the defence value of the unit
  @defence_value: ( defender, terrain_map ) ->
    defender_hex = defender.get_hex()
    terrain_value = terrain_map.hget( defender_hex ).data.color
    dtm = if DEFENCE_TERRAIN_MODIFIER[terrain_value] then DEFENCE_TERRAIN_MODIFIER[terrain_value] else 1

    PAWNS_ATTACK[defender.pawn_type] * dtm

  # Return the ratio string
  @attack_defence_ratio_string: ( attack_value, defence_value ) ->
    if attack_value > defence_value
      return '-' if defence_value == 0
      return Math.round( attack_value/defence_value ) + '-1'
    else
      return '-' if attack_value == 0
      return '1-' + Math.round( defence_value/attack_value )

  # A basic fight for tests
  @basic_fight: ( defender, attack_value, defence_value, result_table, terrain_map ) ->

    defender_hex = defender.get_hex()
    terrain_value = terrain_map.hget( defender_hex ).data.color
    roll_modifier = if DEFENCE_TERRAIN_DICE_MODIFIER[terrain_value] then DEFENCE_TERRAIN_DICE_MODIFIER[terrain_value] else 0
    $('#bonus_dice').html(roll_modifier)

    ratio_string = @attack_defence_ratio_string( attack_value, defence_value )
    roll = @getRandomIntInclusive( 1, 6 )
    $('#final_roll').html(roll)
    $('#modified_roll').html(roll+roll_modifier)

    roll=roll+roll_modifier
    roll = 6 if roll > 6

    result = result_table[roll.toString()][ratio_string]
    $('#fight_result').html(result)
    result

  @getRandomIntInclusive: (min, max) ->
    min = Math.ceil(min);
    max = Math.floor(max);
    Math.floor(Math.random() * (max - min + 1)) + min