import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/set.{type Set}
import gleam/string

pub type Tile {
  Bomb
  Empty(Int)
}

pub type Coord {
  Coord(x: Int, y: Int)
}

pub type Board {
  // Assume the board is square for simplicity
  Board(size: Int, tiles: Dict(Coord, Tile))
}

pub type GameState {
  GameState(board: Board, revealed: Set(Coord), game_over: Bool)
}

pub fn print_board(game_state: GameState) -> String {
  let GameState(board, revealed, _game_over) = game_state
  let Board(size, tiles) = board
  let indices =
    int.range(0, size, list.new(), fn(acc, x) { list.append(acc, [x]) })

  // Header row: "  0 1 2 3 4"
  let header = "  " <> string.join(list.map(indices, int.to_string), " ")

  // Each row: "y tile tile tile ..."
  let rows =
    list.map(indices, fn(y) {
      let row =
        list.map(indices, fn(x) {
          case set.contains(revealed, Coord(x, y)) {
            True ->
              case dict.get(tiles, Coord(x, y)) {
                Ok(Bomb) -> "*"
                Ok(Empty(n)) -> int.to_string(n)
                Error(_) -> "."
              }
            False -> "."
          }
        })
      int.to_string(y) <> " " <> string.join(row, " ")
    })

  string.join([header, ..rows], "\n")
}

pub fn empty_board(size: Int) -> Board {
  let tiles =
    int.range(0, size, dict.new(), fn(acc, x) {
      int.range(0, size, acc, fn(acc, y) {
        dict.insert(acc, Coord(x, y), Empty(1))
      })
    })

  Board(size: size, tiles: tiles)
}

pub fn main() -> Nil {
  let size = 5
  let board = empty_board(size)

  let game = GameState(board: board, revealed: set.new(), game_over: False)
  io.println(print_board(game))
}
