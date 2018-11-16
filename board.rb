class Board

  attr_accessor :table,:table_pieces,:n

  def initialize(n) #makes board

    @table = Hash.new
    @table_pieces = Hash.new
    @n = n

    (1..n).each do |x|
      @table[x] = Hash.new
      (1..n).each do |y|
        @table[x][y] = PointOnBoard.new(x,y)
      end
    end

  end

  def set_piece(object,x,y)
    @table[x][y].give_piece(object) #object is given x,y.
    @table_pieces[object.name] = @table[x][y]
  end

  def move(object,x_new,y_new) #updates positions and object
    @table[object.x][object.y].remove_piece #removes piece from old place
    @table[x_new][y_new].give_piece(object) #gives piece to new place and updates object position
    @table_pieces[object.name] = @table[x_new][y_new]
  end

  def set_depthcharge(x,y)
    @table[x][y].give_piece(DepthCharge.new)
  end

  def on_grid?(x,y) #true / false
    if x.between?(1,@n) and y.between?(1,@n)
      true
    else
      false
    end
  end


  def input_move(name)

    puts "Give move for piece #{name} (e.g B6)"
    input = gets()
    input = input.chomp!
    if input.length != 2
      puts "wrong input"
      input_move(name)
    else
      x,y = input.split("")
      if x =~ /[A-Ga-g]/ and y =~ /[0-7]/
        puts "true"
        x.downcase!
        x_initial = x.upcase
        x_move_input = (x.to_i(32)-9).to_i
        y_move_input = y.to_i
      else
        puts "wrong input"
        input_move(name)
      end
    end
    if possible_moves(@table_pieces[name]).include?([x_move_input,y_move_input])
      #If valid then execute:
      puts "Move #{name} to #{x_initial}#{y_move_input}"
      move(@table_pieces[name].piece,x_move_input,y_move_input)
      to_s
      input_depthcharge(name)
    else
      puts "Invalid move!"
      to_s
      input_move(name)
    end
    #Continue with depthcharge

  end

  def input_depthcharge(name)
    puts "Place depth charge for piece #{name} (e.g A3)"
    input = gets()
    input = input.chomp!
    if input.length != 2
      puts "wrong input"
      input_depthcharge(name)
    else
      x,y = input.split("")
      if x =~ /[A-Ga-g]/ and y =~ /[0-7]/
        puts "true"
        x.downcase!
        x_initial = x.upcase
        x_place_input = (x.to_i(32)-9).to_i
        y_place_input = y.to_i
      else
        puts "wrong input"
        input_depthcharge(name)
      end
    end
    #CHECK IF X AND Y ARE VALID!
    if possible_moves(@table_pieces[name]).include?([x_place_input,y_place_input])
      puts "Place depthcharge at #{x_initial}#{y_place_input}"
      set_depthcharge(x_place_input,y_place_input)
      to_s
    else
      puts "Invalid placement!"
      to_s
      input_depthcharge(name)
    end
  end

  def to_s
    get_string = {
        :white => "W",
        :black => "B",
    }

    @n.downto(1) do |y|
      string = ""
      string += "#{y} "
      1.upto(@n) do |x|
        piece = @table[x][y]
        if piece.empty?
          string += "." #empty
        elsif piece.piece.class.name == "DepthCharge"
          string += "x" #depthcharge
        else
          string += get_string[piece.piece.color] #knight
        end
        string += "  "
      end
      puts string
    end
    puts "  A  B  C  D  E  F  G"

  end

  def possible_moves_in_direction(object,x_yes,y_yes) #do not call!

    moves = []

    x_me = object.x
    y_me = object.y

    (1..5).each do |add|
      x_check = x_me + x_yes*add
      y_check = y_me + y_yes*add

      if on_grid?(x_check,y_check)
        if @table[x_check][y_check].empty?
          moves << [x_check,y_check]
        else
          break
        end
      end

    end
    moves

  end

  def possible_moves(point) #call, give object and returns possibilities

    array_valid_moves = []

    #horizontal right
    array_valid_moves += possible_moves_in_direction(point,1,0)
    #horizontal left
    array_valid_moves += possible_moves_in_direction(point,-1,0)
    #vertical top
    array_valid_moves += possible_moves_in_direction(point,0,1)
    #vertical bottom
    array_valid_moves += possible_moves_in_direction(point,0,-1)
    #diagonal right top
    array_valid_moves += possible_moves_in_direction(point,1,1)
    #diagonal right bottom
    array_valid_moves += possible_moves_in_direction(point,1,-1)
    #diagonal left bottom
    array_valid_moves += possible_moves_in_direction(point,-1,-1)
    #diagonal left top
    array_valid_moves += possible_moves_in_direction(point,-1,1)

    array_valid_moves

  end

end