require('deep_clone')

require_relative('board.rb')

class Node

  @@total_nodes = 0

  attr_reader :depth,:board,:score,:children,:n_children,:piece

  def initialize(depth,piece,board,score=nil)
    @piece = piece
    @depth = depth
    @board = board
    @score = score
    @children = []
    @n_children = 0
    @@total_nodes += 1
  end

  def total_node_output
    @@total_nodes
  end

  def add_children
    if @depth > 0
      next_piece = opponent_name(@piece)
    else
      next_piece = @piece
    end
    children_nodes = best_move_and_depthcharge(@board,next_piece,@depth+1)
    @n_children = children_nodes.length
    @children = children_nodes
  end
end

def result_of_moves_piece(board,piece)

  board_list = []

  #Get moves for piece
  moves = board.possible_moves(board.table_pieces[piece])

  #for each possible move
  moves.each do |x,y|
    #make board clone

    board_search =  DeepClone.clone(board)

    #make move on clone
    board_search.move(board_search.table_pieces[piece].piece,x,y)
    board_list << board_search
  end
  return board_list

end

def result_of_depthcharge(board,piece,depth)

  piece_name = piece
  opp_name = opponent_name(piece_name)
  node_storage = []

  #Get moves for depth_charge
  moves = board.possible_moves(board.table_pieces[piece])

  #for each possible move
  moves.each do |x,y|
    #make board clone

    board_search = DeepClone.clone(board)

    #make move on clone
    board_search.set_depthcharge(x,y)
    #check how many moves me and opponent can me
    n_moves_me = board_search.possible_moves(board_search.table_pieces[piece]).length
    n_moves_opp = board_search.possible_moves(board_search.table_pieces[opp_name]).length
    s = score_function(n_moves_me,n_moves_opp)
    node_storage << Node.new(depth,piece,board_search,s) #depth,piece,board,score=nil
  end
  return node_storage
end

def best_move_and_depthcharge(board,piece,depth)

  boards_move = result_of_moves_piece(board,piece)
  nodes_all_possible = []
  boards_move.each do |board_check|
    nodes_all_possible += result_of_depthcharge(board_check,piece,depth)
  end
  nodes_all_possible
end


