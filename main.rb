require_relative('search.rb')
require_relative('board.rb')

def score_function(n_me,n_enemy)
  s = n_me - n_enemy
  return s
end

class PointOnBoard
  attr_reader :x,:y
  attr_accessor :piece

  def initialize(x,y,piece = false)
    @x = x
    @y = y
    @piece = piece
  end

  def empty?
    if @piece == false
      true
    else
      false
    end
  end

  def give_piece(object)
    @piece = object
    object.x = @x
    object.y = @y
  end

  def remove_piece
    @piece = false
  end

end

class Knight
  attr_accessor :x, :y
  attr_reader :name,:color
  def initialize(name,color)
    @x,@y,@color,@name = nil,nil,color,name
  end
end

class DepthCharge
  attr_accessor :x, :y
  attr_reader :name
  def initialize
    @x,@y,@name = nil,nil,self.class.name
  end
end

def opponent_name(self_name)
  opponent_name = {
      :white1 => :black1,
      :black1 => :white1,
  }
  opponent_name[self_name]
end

#Iterative add moves, two layers deep:

def tree_maker(node)
  max_depth = 1
  if node.depth <= max_depth
    #puts node.depth
    node.add_children
    #puts "Now children..."
    node.children.each do |child|
      #puts child.depth
      tree_maker(child)
    end
  end
end

#puts rootnode.n_children
#puts "depth: #{rootnode.children[0].depth}"
#puts "depth: #{rootnode.children[0].children[0].depth}"


def negamax(tree)
  values = []
  boards = []
  if tree.n_children != 0
    tree.children.each do |child|
      val,board_child = negamax(child)
      values << val
      boards << child.board
    end
  else #rootnode
      return tree.score,tree.board
  end
  max_val = values.max()
  i_max_val = values.index(max_val)
  board_max = boards[i_max_val]
  return -max_val,board_max
end


def negamax_deepestboard(tree)
  values = []
  boards = []
  if tree.n_children != 0
    tree.children.each do |child|
      val,boardz = negamax(child)
      values << val
      boards << boardz
    end
  else #rootnode
    return tree.score,tree.board
  end
  max_val = values.max()
  return -max_val,boards[values.index(max_val)]
end

#Make Board
board = Board.new(7)
#Set black and white piece
board.set_piece(Knight.new(:white1,:white),4,1)
board.set_piece(Knight.new(:black1,:black),4,7)
board.to_s
puts "You are Black, give us your move:"
10.times do
  board.input_move(:black1)
  #Let computer play
  puts "Computer is thinking..."
  rootnode = Node.new(0,:white1,board,0)
  starting = Time.now
  tree_maker(rootnode)
  elapsed = Time.now - starting
  puts "Time #{elapsed}"
  puts "Moves evaluated: #{rootnode.total_node_output}"
  max_val,board = negamax(rootnode)
  puts "Computer plays this:"
  board.to_s
end

#max_val_deepest,max_board_depest = negamax_deepestboard(rootnode)
#puts "Max value = #{max_val}"
#max_board.to_s
#puts "Max value = #{max_val_deepest}"
#max_board_depest.to_s
#puts rootnode.piece
#puts rootnode.children[0].piece
#puts rootnode.children[0].children[0].piece


#rootnode.children.each do |child|
#  puts child.depth
#  puts child.score
#  child.board.to_s
#end

#puts "Now Blacks makes this move:"
#nodelist = best_move_and_depthcharge(board,:white1,0)
#nodelist.each{|node| puts node.board}



















#board.input_move(:white1)
#x_move,y_move =  moves[1]
#puts "Moving to #{x_move},#{y_move}."
#Execute move
#board.move(board.table_pieces[:white1].piece,x_move,y_move)
#Check result

#Position 6,4 should now contain white1
#Position 4,4 should be empty

#puts board.table[4][4].empty? #=> True
#puts board.table[6][4].empty? #=> False
#puts board.table[6][4].piece.name #6,4 contains white1!



#puts possible_moves.length #number of moves possible


#Let Black make a move so that white has the least possible moves available.