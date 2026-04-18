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
  Board(size: Int, bombs: Set(Coord))
}

pub type GameState {
  GameState(board: Board, revealed: Set(Coord), game_over: Bool)
}

// Generate random set of coords for bombs.
// Recursively sample bombs until we have enough.
fn sample_bombs(
  size: Int,
  remaining: Int,
  acc: set.Set(Coord),
) -> set.Set(Coord) {
  case set.size(acc) >= remaining {
    True -> acc
    False -> {
      let coord = Coord(int.random(size), int.random(size))
      sample_bombs(size, remaining, set.insert(acc, coord))
    }
  }
}

// Check if a coordinate is valid
fn valid_coord(size: Int, coord: Coord) -> Bool {
  let Coord(x, y) = coord
  x >= 0 && x < size && y >= 0 && y < size
}

// Get the valid neighbors of a tile
pub fn neighbors(size: Int, coord: Coord) -> List(Coord) {
  let Coord(x, y) = coord
  // List of all possible direction offsets.
  // (dx, dy)
  [
    #(-1, -1),
    #(0, -1),
    #(1, -1),
    // middle row
    #(-1, 0),
    #(1, 0),
    // bottom row
    #(-1, 1),
    #(0, 1),
    #(1, 1),
  ]
  |> list.map(fn(offset) {
    let #(dx, dy) = offset
    Coord(x + dx, y + dy)
  })
  |> list.filter(valid_coord(size, _))
}

pub fn count_bombs(coord: Coord, board: Board) -> Int {
  let Board(size, bombs) = board
  neighbors(size, coord)
  |> list.filter(set.contains(bombs, _))
  |> list.length()
}

pub fn tile_at(board: Board, coord: Coord) -> Tile {
  case set.contains(board.bombs, coord) {
    True -> Bomb
    False -> Empty(count_bombs(coord, board))
  }
}

// Initialize a new board with random bombs.
// (This is a pure function)
pub fn init_board(size: Int, bombs: Int) -> Board {
  // Get random coordinates for bombs.
  let bomb_coords = sample_bombs(size, bombs, set.new())

  Board(size: size, bombs: bomb_coords)
}

pub fn print_board(game_state: GameState) -> String {
  let GameState(board, revealed, _game_over) = game_state
  let size = board.size

  // Header row: "  0 1 2 3 4"
  let header =
    int.range(from: 0, to: size, with: "  ", run: fn(acc, x) {
      acc <> int.to_string(x) <> " "
    })

  // Each row: "y . . 1 * ..."
  let rows =
    int.range(from: 0, to: size, with: [], run: fn(acc, y) {
      let row =
        int.range(
          from: 0,
          to: size,
          with: int.to_string(y) <> " ",
          run: fn(acc, x) {
            let coord = Coord(x, y)
            let cell = case set.contains(revealed, coord) {
              False -> "."
              True ->
                case tile_at(board, coord) {
                  Bomb -> "*"
                  Empty(0) -> " "
                  Empty(n) -> int.to_string(n)
                }
            }
            acc <> cell <> " "
          },
        )
      [row, ..acc]
    })

  // Rows were prepended, so reverse to get top-to-bottom order
  let rows = list.reverse(rows)

  string.join([header, ..rows], "\n")
}

pub fn main() -> Nil {
  let size = 5
  let bombs = 5
  let board = init_board(size, bombs)

  let game = GameState(board: board, revealed: set.new(), game_over: False)
  io.println(print_board(game))
}
