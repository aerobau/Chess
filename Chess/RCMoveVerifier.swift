//
//  RCMoveVerifier.swift
//  Chess
//
//  Created by Alexander Robau on 9/17/15.
//  Copyright (c) 2015 Alexander Robau. All rights reserved.
//

import Foundation

class RCMoveVerifier {
  // Method that will be overriden to check if the move is valid and update it if necessary
  func verifyMove(move: RCChessMove, moveDelegate: RCMoveDelegate) -> RCChessMove? {
    // The default for this Method will be to say that the move is invalid and set it to nil, this
    // will be overriden in the subclasses
    return nil
  }
  
  // PATH VERIFICATION HANDLING //
  
  // The path a move requires will be verified by iterating through all of the squares in a path
  // and making sure no squares have pieces that block the path.  Additionally, the destination
  // square will be analized to make sure that if it has a piece to be captured, that piece is of a
  // different color from the piece that is making the move.
  
  // Function to set up and dispatch iterations to verify that the path the move needs to make is
  // a valid path, will dispatch to sub functions for different path types
  final func verifyMovementPath(start: RCChessCoordinate, destination: RCChessCoordinate,
    moveDelegate: RCMoveDelegate) -> Bool {
    let direction = pathDirection(start, destination: destination)
    return verifyPath(start: start, destination: destination, direction: direction,
      moveDelegate: moveDelegate)
  }
  
  // Simple enumeration to detail the different cases of path directions that are possible from the
  // movements of the pieces
  private enum RCPathDirection {
    case positiveDiagonalForward // Positive slope diagonal in the forward direction
    case negativeDiagonalForward // Negative slope diagonal in the forward direction
    case positiveDiagonalBackward // Positive slope diagonal in the backward direction
    case negativeDiagonalBackward // Negative slope diagonal in the backward direction
    case columnUp // Moving up a column
    case columnDown // Moving down a column
    case rowRight // Moving right on a row
    case rowLeft // Moving left on a row
    case none // Not a valid move direction
  }
  
  // Function to derermine the path direction and return it to indicate what the path direction is
  // in order to properly set up the iteration
  private final func pathDirection(start: RCChessCoordinate, destination: RCChessCoordinate)
    -> RCPathDirection {
    // Getting the row and column differences
    let rowDifference = destination.row - start.row
    let columnDifference = destination.column - start.column
    
    // If statements to determine which direction it is and return the proper direction
    if rowDifference == columnDifference && rowDifference == 0 {
      return .none
    } else if rowDifference == columnDifference && rowDifference > 0 {
      return .positiveDiagonalForward
    } else if rowDifference == columnDifference && rowDifference < 0 {
      return .positiveDiagonalBackward
    } else if rowDifference == (columnDifference * -1) && rowDifference < 0 {
      return .negativeDiagonalForward
    } else if rowDifference == (columnDifference * -1) && rowDifference > 0 {
      return .negativeDiagonalBackward
    } else if rowDifference > 0 && columnDifference == 0 {
      return .columnUp
    } else if rowDifference < 0 && columnDifference == 0 {
      return .columnDown
    } else if rowDifference == 0 && columnDifference > 0 {
      return .rowRight
    } else if rowDifference == 0 && columnDifference < 0 {
      return .rowLeft
    } else {
      return .none
    }
  }
  
  // First verify path function that sets up the column and row increments and then calls the second
  // verify path function that actually iterates through the path
  private final func verifyPath(start start: RCChessCoordinate, destination: RCChessCoordinate,
    direction: RCPathDirection, moveDelegate: RCMoveDelegate) -> Bool {
      // Declaring variables for the column increment and row increment
      let columnIncrement: Int!
      let rowIncrement: Int!
      
      // Setting up the column and row increment
      switch direction {
      case .positiveDiagonalForward: columnIncrement = 1; rowIncrement = 1
      case .negativeDiagonalForward: columnIncrement = 1; rowIncrement = -1
      case .positiveDiagonalBackward: columnIncrement = -1; rowIncrement = -1
      case .negativeDiagonalBackward: columnIncrement = -1; rowIncrement = 1
      case .columnDown: columnIncrement = 0; rowIncrement = -1
      case .columnUp: columnIncrement = 0; rowIncrement = 1
      case .rowRight: columnIncrement = 1; rowIncrement = 0
      case .rowLeft: columnIncrement = -1; rowIncrement = 0
      case .none: return false
      }
      
      // Calling the verify path function that actually sets up the iteration and performs it
      return verifyPath(columnIncrement, rowIncrement: rowIncrement, start: start,
        destination: destination, moveDelegate: moveDelegate)
  }
  
  // Function that actually iterates through the chess squares and verifies that the move can be
  // made
  private final func verifyPath(columnIncrement: Int, rowIncrement: Int, start: RCChessCoordinate,
    destination: RCChessCoordinate, moveDelegate: RCMoveDelegate) -> Bool {
      // Setting up the iterator values for the column and row
      var iteratorColumn = start.column, iteratorRow = start.row
      
      // Saving the start position to compare pieces later
      let startSquare = moveDelegate[iteratorColumn][iteratorRow]
      
      // Iterating through all of the areas between the start column and the destination column to
      // make sure there are no pieces there
      while iteratorColumn != (destination.column - columnIncrement) ||
        iteratorRow != (destination.row - rowIncrement) {
          iteratorColumn += columnIncrement
          iteratorRow += rowIncrement
          if moveDelegate[iteratorColumn][iteratorRow].piece != nil {
            return false
          }
      }
      
      // Checks to make sure theres a mismatch between the moving piece and the possible piece at the
      // destination having already successfully made sure there were no pieces in between them
      if let destinationPiece = moveDelegate[destination.column][destination.row].piece {
        return destinationPiece.color != startSquare.piece?.color
      } else {
        return true
      }
  }
}