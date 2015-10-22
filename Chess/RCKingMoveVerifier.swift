//
//  RCKingMoveVerifier.swift
//  Chess
//
//  Created by Alexander Robau on 9/20/15.
//  Copyright (c) 2015 Alexander Robau. All rights reserved.
//

import Foundation

class RCKingMoveVerifier: RCMoveVerifier {
  override func verifyMove(move: RCChessMove, moveDelegate: RCMoveDelegate) -> RCChessMove? {
    // Getting the absolute value of the proposed move's x and y
    let columnMovementMagnitude = abs(move.columnMovement)
    let rowMovementMagnitude = abs(move.rowMovement)
    
    // The king only has a range of one
    if columnMovementMagnitude <= 1 && rowMovementMagnitude <= 1 {
      // Verifying the movement, if it is legal, return the proposed move, otherwise return nil
      if verifyMovementPath(move.start, destination: move.destination, moveDelegate: moveDelegate) {
        move.flag = .kingMove
        return move
      } else {
        return nil
      }
    } else if columnMovementMagnitude == 2 && rowMovementMagnitude == 0 &&
      !move.piece.moved {
        // Checking to see if a castle is possible
        // Setting up the rook's destination
        let rookDestinationColumn = move.start.column + (move.columnMovement / 2)
        let rookDestination =
        RCChessCoordinate(column: rookDestinationColumn, row: move.start.row)
        
        // Two different scenarios, castling right or castling left
        if move.columnMovement > 0 {
          // Castling to the right, rook will be at column 7
          let rookStart = RCChessCoordinate(column: 7, row: move.start.row)
          
          // Checking to see if a piece actually exists where the rook should be
          if let piece = moveDelegate[rookStart.column][rookStart.row].piece {
            // If the piece at column 7 has not been moved then it is indeed a rook and is eligible
            // for castling.  Thus, set legal as a constant indicating whether the castle is 
            // possible or not
            let legal = !piece.moved && verifyMovementPath(rookStart, destination: rookDestination,
              moveDelegate: moveDelegate)
            
            // Set the flag for castle and return the move if the move is legal, otherwise return 
            // nil
            if legal {
              move.flag = .castle
              return move
            }
            else {
              return nil
            }
          } else {
            // Since the piece was not there, the castle is inherently illegal, return nil
            return nil
          }
        } else {
          // Castling to the left, rook will be at column 0
          let rookStart = RCChessCoordinate(column: 0, row: move.start.row)
          
          // Checking to see if a piece actually exists where the rook should be
          if let piece = moveDelegate[rookStart.column][rookStart.row].piece {
            // If the piece at column 0 has not been moved then it is indeed a rook and is eligible
            // for castling.  Thus, set legal as a constant indicating whether the castle is 
            // possible or not
            let legal = !piece.moved && verifyMovementPath(rookStart, destination: rookDestination,
              moveDelegate: moveDelegate)
            
            // Set the flag for castle and return the move if the move is legal, otherwise return 
            // nil
            if legal {
              move.flag = .castle
              return move
            }
            else {
              return nil
            }
          } else {
            // Since the piece was not there, the castle is inherently illegal, return nil
            return nil
          }
        }
    } else {
      // The move is not possible for a king, return nil
      return nil
    }
  }
}