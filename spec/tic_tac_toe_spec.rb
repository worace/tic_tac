require File.dirname(__FILE__) + "../../lib/tic_tac_toe"
RSpec.describe TicTacToe::Game do
  let (:game) { TicTacToe::Game.new }
  it "plays a letter for a given square" do
    game.board.play(1, "X")
    expect(game.board.square_for_move(1).value).to eq("X")
  end

  it "knows when a player has won on a row" do
    (1..3).each { |i| game.board.play(i, "X") }
    expect(game.ended?).to be(true)
    game = TicTacToe::Game.new
    (4..6).each { |i| game.board.play(i, "O") }
    expect(game.ended?).to be(true)
  end

  it "knows when a player has won on a column" do
    [1,4,7].each { |i| game.board.play(i, "X")  }
    expect(game.ended?).to be(true)
    game = TicTacToe::Game.new
    [2,5,8].each { |i| game.board.play(i, "O")  }
    expect(game.ended?).to be(true)
  end

  it "knows when a player has won on a diagonal" do
    [1,5,9].each { |i| game.board.play(i, "X")  }
    expect(game.ended?).to be(true)
    game = TicTacToe::Game.new
    [3,5,7].each { |i| game.board.play(i, "O")  }
    expect(game.ended?).to be(true)
  end

  it "doesnt think an un-won game is ended" do
    game.board.play(1, "X")
    expect(game.ended?).to be(false)
    game.board.play(2, "Y")
    game.board.play(3, "Y")
    expect(game.ended?).to be(false)
  end

  it "displays the board with to_s" do
    display = " 1 | 2 | 3 
____________
 4 | 5 | 6 
____________
 7 | 8 | 9 "
    expect(game.board.to_s).to eq(display)

  end
end

RSpec.describe Matrix do
  let(:matrix) { Matrix.build(3) { |r, c| c + r*3 + 1 } }

  it "gives 1,5,9 for #first_diagonal" do
    expect(matrix.first_diagonal).to eq([1,5,9])
  end

  it "gives 3,5,7 for #reverse_diagonal" do
    expect(matrix.reverse_diagonal).to eq([7,5,3])
  end

  it "gives both for #diagonal_vectors" do
    expect(matrix.diagonal_vectors).to eq([[1,5,9], [7,5,3]])
  end
end
