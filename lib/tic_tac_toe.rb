require "matrix"

module TicTacToe
  class Application
    def run
      display_launch_options
    end

    def display_launch_options
      puts "n: New Game"
      puts "q: Quit"
      selection = gets
      case selection.chars.first.downcase
      when "q"
        #quit
      when "n"
        Game.new.play
      else
        puts "sorry didnt get that, try these:"
        display_launch_options
      end
    end
  end

  class Game
    attr_accessor :current_round

    def ended?
      won || cat
    end

    def won
      VictoryDetector.new(board).won?
    end

    def cat
      false
    end

    def current_round
      @current_round ||= 1
    end

    def current_player
      ["X", "O"][current_round % 2]
    end

    def play
      while !ended?
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
      puts game_ended_message
    end

    def game_over_message
      if game.won?
        puts "you win!"
      else
        puts "game tied!"
      end
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
      square_for_move(move).available?
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

    def rows; [[1,2,3], [4,5,6], [7,8,9]]; end
    def cols; [[1,4,7], [2,5,8], [3,6,9]]; end
    def diags; [[1,5,9], [3,5,7]]; end

    def won?
      row_victory? || col_victory? || diag_victory?
    end

    def row_victory?
      board.squares.row_vectors.any? { |v| victory_vector?(v) }
    end

    def col_victory?
      board.squares.column_vectors.any? { |v| victory_vector?(v) }
    end

    def diag_victory?
      board.squares.diagonal_vectors.any? { |v| victory_vector?(v) }
    end

    def victory_vector?(vector)
        vector.count == 3 &&
        vector.all? { |r| r.x? } ||
        vector.all? { |r| r.o? }
    end
  end
end

class Matrix
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
#TicTacToe::Application.new.run
