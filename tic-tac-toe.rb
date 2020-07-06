class Tic_tac_toe #gameplay
  def initialize
    @board = Board.new
    @player_one = Player.new("player one", :X, @board)
    @player_two = Player.new("player two", :O, @board)
    @current_player = @player_one #assign starting player
  end

    def play
        loop do
          @board.render
          @current_player.get_coordinates
          break if check_game_over
          switch_players
        end
    end
    def check_game_over
        check_victory || check_draw
    end
    def check_victory
      if @board.winning_combination?(@current_player.piece) #if board says current player has a winning combination
        puts "#{@current_player.name} won!"
        true
      else
        false
      end
    end
    def check_draw
      if @board.full?
        puts "it's a draw"
        true
      else
        false
      end
    end
    def switch_players
        if @current_player == @player_one
            @current_player = @player_two
        else
            @current_player = @player_one
        end
    end
end

class Player #interacts with player
  attr_accessor :name, :piece
  def initialize (name = "unknown", piece, board)
        # Set marker type (e.g. X or O)
        raise "Piece must be X or O " unless piece.is_a?(Symbol)
        @name = name
        @piece = piece
        @board = board
  end
    def get_coordinates
      loop do
        coords = ask_for_coordinates
        if validate_coordinates_format(coords) #if coords are valid
          if @board.add_piece(coords, @piece) #if piece can be placed on Board
            break
          end
        end
      end
    end
    def ask_for_coordinates
      puts "#{@name}(#{@piece}), enter coordinates in x,y format " #ask for coordinates
      gets.strip.split(",").map(&:to_i)
    end
    def validate_coordinates_format (coords)# validate_coordinates
      if coords.is_a?(Array) && coords.size == 2  # UNLESS coordinates are in the proper format
          true
        else
          puts "bad coords"
        end
      end
end

class Board #maintains board
  def initialize
    @board = Array.new(3){Array.new(3)} #blank 3x3
  end
  def render
      puts
      @board.each do |row|
          row.each do |cell|
              cell.nil? ? print("-") : print(cell.to_s)
          end
          puts
      end
      puts

  end

    def add_piece(coords, piece)
      if piece_location_valid?(coords)
        @board[coords[0]][coords[1]] = piece
        true
      else
        false
      end
    end
    def piece_location_valid?(coords) #checs if position is valid
      if within_valid_coordinates?(coords)
        coordinates_available?(coords) #checks if position is empty
      end
    end
    def within_valid_coordinates?(coords)
      if(0..2).include?(coords[0]) && (0..2).include?(coords[1])
        true
      else
        puts "coords out of bounds"
      end
    end
    def coordinates_available?(coords)
        if @board[coords[0]][coords[1]].nil? #checs if position is occupied
            true
        else
            puts "cell is occupied"
        end
    end
    def winning_combination?(piece)
        winning_diagonal?(piece)   ||  winning_horizontal?(piece) ||  winning_vertical?(piece)
    end

    def winning_diagonal?(piece)
        diagonals.any? do |diagonal|
            diagonal.all?{|cell| cell == piece }
        end
    end
    def winning_vertical?(piece)
      verticals.any? do |vertical|
        vertical.all?{|cell| cell == piece }
      end
    end
    def winning_horizontal?(piece)
      horizontals.any? do |horizontal|
        horizontal.all?{|cell| cell == piece }
      end
    end
    def diagonals
            [[ @board[0][0],@board[1][1],@board[2][2] ],[ @board[2][0],@board[1][1],@board[0][2] ]]
        end
        def verticals
            @board
        end
        def horizontals
            horizontals = []
            3.times do |i|
                horizontals << [@board[0][i],@board[1][i],@board[2][i]]
            end
            horizontals
        end

        def full?
            # does every square contain a piece?
            @board.all? do |row|
                row.none?(&:nil?)
            end
        end
      end

    t = Tic_tac_toe.new
    t.play
