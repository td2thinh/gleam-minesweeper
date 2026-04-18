import gleam/dict
import gleam/list
import gleam/set
import gleeunit
import minesweeper.{Board, Bomb, Coord, Empty, GameState}

pub fn main() -> Nil {
  gleeunit.main()
}

// ---------------------------------------------------------------------------
// neighbors
// ---------------------------------------------------------------------------

pub fn neighbors_top_left_corner_test() {
  let result = minesweeper.neighbors(5, Coord(0, 0))
  assert list.length(result) == 3
  assert list.contains(result, Coord(1, 0))
  assert list.contains(result, Coord(0, 1))
  assert list.contains(result, Coord(1, 1))
}

pub fn neighbors_top_right_corner_test() {
  let result = minesweeper.neighbors(5, Coord(4, 0))
  assert list.length(result) == 3
  assert list.contains(result, Coord(3, 0))
  assert list.contains(result, Coord(3, 1))
  assert list.contains(result, Coord(4, 1))
}

pub fn neighbors_bottom_left_corner_test() {
  let result = minesweeper.neighbors(5, Coord(0, 4))
  assert list.length(result) == 3
  assert list.contains(result, Coord(0, 3))
  assert list.contains(result, Coord(1, 3))
  assert list.contains(result, Coord(1, 4))
}

pub fn neighbors_bottom_right_corner_test() {
  let result = minesweeper.neighbors(5, Coord(4, 4))
  assert list.length(result) == 3
  assert list.contains(result, Coord(3, 3))
  assert list.contains(result, Coord(4, 3))
  assert list.contains(result, Coord(3, 4))
}

pub fn neighbors_top_edge_test() {
  let result = minesweeper.neighbors(5, Coord(2, 0))
  assert list.length(result) == 5
  assert list.contains(result, Coord(1, 0))
  assert list.contains(result, Coord(3, 0))
  assert list.contains(result, Coord(1, 1))
  assert list.contains(result, Coord(2, 1))
  assert list.contains(result, Coord(3, 1))
}

pub fn neighbors_left_edge_test() {
  let result = minesweeper.neighbors(5, Coord(0, 2))
  assert list.length(result) == 5
  assert list.contains(result, Coord(0, 1))
  assert list.contains(result, Coord(1, 1))
  assert list.contains(result, Coord(1, 2))
  assert list.contains(result, Coord(0, 3))
  assert list.contains(result, Coord(1, 3))
}

pub fn neighbors_middle_test() {
  let result = minesweeper.neighbors(5, Coord(2, 2))
  assert list.length(result) == 8
  assert list.contains(result, Coord(1, 1))
  assert list.contains(result, Coord(2, 1))
  assert list.contains(result, Coord(3, 1))
  assert list.contains(result, Coord(1, 2))
  assert list.contains(result, Coord(3, 2))
  assert list.contains(result, Coord(1, 3))
  assert list.contains(result, Coord(2, 3))
  assert list.contains(result, Coord(3, 3))
}

pub fn neighbors_does_not_include_self_test() {
  let result = minesweeper.neighbors(5, Coord(2, 2))
  assert !list.contains(result, Coord(2, 2))
}

pub fn neighbors_size_one_test() {
  let result = minesweeper.neighbors(1, Coord(0, 0))
  assert result == []
}

}
