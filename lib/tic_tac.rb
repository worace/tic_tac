require "matrix"

module TicTac
  class Application
    def run
      while true
        puts "n: New Game"
        puts "q: Quit"
        selection = gets.chomp
        case selection.chars.first.to_s.downcase
        when "q"
          puts "See you later!"
          break
        when "n"
          play_game
        else
          puts "sorry didnt get that, try these:"
        end
      end
      return 0
    end

    def play_game
      game = Game.new
      while !game.ended?
        game.play_turn
      end
      puts game.game_over_message
    end
  end

  class Game
    attr_accessor :current_round

    def ended?
      won? || cat?
    end

    def won?
      VictoryDetector.new(board).won?
    end

    def cat?
      CatDetector.new(board).cat?
    end

    def current_round
      @current_round ||= 1
    end

    def current_player
      ["X", "O"][current_round % 2]
    end

    def last_player
      (["X", "O"] - [current_player]).first
    end

    def play_turn
      puts "Turn #{current_round}. #{current_player} is up. Current board is:\n\n"
      puts board
      puts "\nPlay a square by entering the number of the square you would like to play.\n"

      move = gets.chomp.to_i
      if board.available?(move)
        puts "you selected: #{move}"
        board.play(move, current_player)
        self.current_round = current_round.to_i + 1
      else
        puts "#{move} is not available"
      end
    end

    def game_over_message
      if won?
        puts "#{last_player}'s win!"
        puts "final position was:"
        puts board
      else
        puts "C-A-T! Game Tied!"
        puts "final position was:"
        puts board
      end
      puts "\n\nPlay again?\n"
    end

    def board
      @board ||= Board.new
    end
  end

  class Board
    def play(move, player)
      square_for_move(move).value = player
    end

    def squares
      @squares ||= Matrix.build(3) { |r, c| Square.new(c + r*3 + 1) }
    end

    def to_s
      squares.row_vectors.map { |row| row.to_a.map(&:to_s).join("|") }.join("\n____________\n")
    end

    def available?(move)
      !!square_for_move(move) && square_for_move(move).available?
    end

    def square_for_move(move)
      squares.to_a.flatten[move-1]
    end

    def x_s
      squares.select(&:x?)
    end

    def o_s
      squares.select(&:o?)
    end
  end

  class Square
    attr_accessor :value
    attr_reader :index
    def initialize(index)
      @index = index
    end

    def to_s
      " #{value || index} "
    end

    def available?
      !(x? || o?)
    end

    def x?
      value.to_s.downcase == "x"
    end

    def o?
      value.to_s.downcase == "o"
    end
  end

  class VictoryDetector
    attr_reader :board
    def initialize(board)
      @board = board
    end

    def won?
      board.squares.vectors_with_diagonals.any? { |v| victory_vector?(v) }
    end

    def victory_vector?(vector)
        vector.count == 3 &&
        vector.all? { |square| square.x? } ||
        vector.all? { |square| square.o? }
    end
  end

  class CatDetector
    attr_reader :board
    def initialize(board)
      @board = board
    end

    def cat?
      board.squares.vectors_with_diagonals.all? { |v| blocked_vector?(v) }
    end

    def blocked_vector?(vector)
      vector.to_a.map(&:value).compact.uniq.count > 1
    end
  end
end

class Matrix

  def vectors_with_diagonals
    row_vectors + column_vectors + diagonal_vectors
  end

  def diagonal_vectors
    [first_diagonal, reverse_diagonal]
  end

  def first_diagonal
    lower = []
    upper = []
    each(:lower) { |s| lower << s }
    each(:upper) { |s| upper << s }
    lower & upper
  end

  def reverse_diagonal
    Matrix[*row_vectors.reverse].first_diagonal
  end
end
