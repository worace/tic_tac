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
      false
    end

    def won

    end

    def cat

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
      #puts game_ended_message
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
      @squares ||= (1..9).each_slice(3).map { |s| s.map { |index| Square.new(index) } }
    end

    def to_s
      squares.map { |row| row.map(&:to_s).join("|") }.join("\n____________\n")
    end

    def available?(move)
      square_for_move(move).available?
    end

    def square_for_move(move)
      squares.flatten[move-1]
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
end

TicTacToe::Application.new.run
