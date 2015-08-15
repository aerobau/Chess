//
//  ChessSquare.swift
//  Chess
//
//  Created by Alexander Robau on 6/19/14.
//  Copyright (c) 2015 Robau Industries. All rights reserved.
//

import Foundation

// Simple chess coordinate struct
struct RCChessCoordinate {
  var column: Int
  var row: Int
  
  init(column: Int = -1, row: Int = -1) {
    self.column = column
    self.row = row
  }
}

struct RCChessSquare {
  var piece: RCChessPiece?
  var coordinate: RCChessCoordinate
  
  init(piece: RCChessPiece? = nil,
    coordinate: RCChessCoordinate = RCChessCoordinate(column: 0, row: 0)) {
    self.piece = piece
    self.coordinate = coordinate
  }
}
