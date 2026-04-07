import gleam/dict.{type Dict}
import gleam/io
import gleam/set.{type Set}

type Tile {
  Bomb
  Empty(Int)
}

type Coord {
  Coord(x: Int, y: Int)
}

type Board {
  // Assume the board is square for simplicity
  Board(size: Int, tiles: Dict(Coord, Tile))
}

type GameState {
  GameState(board: Board, revealed: Set(Coord), game_over: Bool)
}

pub fn main() -> Nil {
  io.println("Hello from minesweeper!")
}
