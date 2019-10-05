class PawnsController < ApplicationController

	before_action :set_and_check_pawn

  # Update is for movement only
  def update
    p = Pawn.find( params[:id])
    p.update!( q: params[:q], r: params[:r], has_moved: params[:has_moved] )
    head :ok
  end

  def destroy
		@pawn.destroy!
    head :ok
  end

  private

	def set_and_check_pawn
		@pawn = Pawn.find( params[:id])
		@board = pawn.board

		unless @board.send( "#{@pawn.side}_id" ) == current_player.id
			raise "Pawn moved by player that is not the owner. Pawn : #{@pawn.inspect}, board : #{@board.inspect}"
		end

	end

end
