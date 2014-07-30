require File.dirname(__FILE__) + "../../tic_tac_toe"
RSpec.describe TicTacToe::Game do
  let (:game) { TicTacToe::Game.new }
  it "plays a letter for a given square" do
    game.board.play(1, "X")
    expect(game.board.square_for_move(1).value).to eq("X")
  end

  it "knows when a player has won on a row" do
    (1..3).each { |i| game.board.play(i, "X") }
    expect(game.ended?).to be(true)
    (1..3).each { |i| game.board.play(i, "O") }
    expect(game.ended?).to be(true)
  end

  it "doesnt think an un-won game is ended" do
    game.board.play(1, "X")
    expect(game.ended?).to be(false)
  end
end
