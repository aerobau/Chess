//
//  ChessBoard.swift
//  Chess
//
//  Created by Alexander Robau on 6/19/14.
//  Copyright (c) 2015 Robau Industries. All rights reserved.
//

import Foundation

class RCChessBoard {
  var board: [[RCChessSquare]]
  var blackKingCoordinate = RCChessCoordinate()
  var whiteKingCoordinate = RCChessCoordinate()
  var blackCapturedPieces = [RCChessPiece]()
  var whiteCapturedPieces = [RCChessPiece]()
  var homeColor = RCPieceColor.White
  
  init(board: [[RCChessSquare]]) {
    self.board = board
    self.blackKingCoordinate = findKing(board, color: .Black)
    self.whiteKingCoordinate = findKing(board, color: .White)
  }
  
  
  // MOVE LEGALITY DETERMINATION HANDLING //
  
  // Moves will be determined if they are legal by a series of dispatches.
  
  // Generic umbrella method to verify any given move, will dispatch to sub functions
  func verifyMove(proposedMove: RCChessMove) -> RCChessMove? {
    switch proposedMove.piece.type {
      case .Pawn: return verifyPawnMove(proposedMove)
      case .Rook: return verifyRookMove(proposedMove)
      case .Knight: return verifyKnightMove(proposedMove)
      case .Bishop: return verifyBishopMove(proposedMove)
      case .Queen: return verifyQueenMove(proposedMove)
      case .King: return verifyKingMove(proposedMove)
      case .Undefined: return nil
    }
  }
  
  // Specific function to determine if a pawn move is legal
  func verifyPawnMove(proposedMove: RCChessMove) -> RCChessMove? {
    // Getting the positive column movement
    let columnMovementMagnitude = abs(proposedMove.columnMovement)
    let rowMovementMagnitude = abs(proposedMove.rowMovement)
    
    // Diagonal movement, must be a capture of some sort
    if columnMovementMagnitude == 1 && columnMovementMagnitude == 1 {
      // Determining if this is an en passant capture
      let opponentPieceEnPassant: Bool
      if let piece = board[proposedMove.destination.column][proposedMove.start.row].piece {
        // There is a piece en passant, determine if it is a different color pawn
        opponentPieceEnPassant = validCaptureForEnPassant(piece)
      } else {
        opponentPieceEnPassant = false
      }
      
      // Determining if this is a normal capture
      let opponentPieceDiagonal: Bool
      if let piece = board[proposedMove.destination.column][proposedMove.destination.row].piece {
        // There is a piece diagonally, determine if it is of a different color
        opponentPieceDiagonal = piece.color != proposedMove.piece.color
      } else {
        opponentPieceDiagonal = false
      }
      
      // The following if statements make sure that the piece is moving only in the correct
      // direction due to pawns having a one way system
      if proposedMove.rowMovement == 1 && proposedMove.piece.color == homeColor {
        // Pawn is moving upwards with the home color
        if opponentPieceDiagonal {
          // The move is a regular capture
          return proposedMove
        } else if opponentPieceEnPassant {
          // The move is an enpassant capture, set the flag to enpassant and return the move
          proposedMove.flag = .enPassant
          return proposedMove
        } else {
          // The move is not legal, return a nil chess move
          return nil
        }
      } else if proposedMove.rowMovement == -1 && proposedMove.piece.color != homeColor {
        // Pawn is moving downwards without the home color
        if opponentPieceDiagonal {
          // The move is a regular capture
          return proposedMove
        } else if opponentPieceEnPassant {
          // The move is an enpassant capture, set the flag to enpassant and return the move
          proposedMove.flag = .enPassant
          return proposedMove
        } else {
          // The move is not legal, return a nil chess move
          return nil
        }
      } else {
        // The move is not legal, return a nil chess move
        return nil
      }
    }
    
    // If the row movement is 2 it can only be an opening move, and the column movement must = 0
    else if rowMovementMagnitude == 2 && columnMovementMagnitude == 0 {
      // Getting the row of the square in the middle of the destination and start
      let midSpaceRow = proposedMove.start.row + (proposedMove.rowMovement / 2)
      
      // Setting a boolean validMove to whether or not the move is valid
      let validMove = !proposedMove.piece.moved &&
        board[proposedMove.destination.column][proposedMove.destination.row].piece == nil &&
        board[proposedMove.start.column][midSpaceRow].piece == nil
      
      // If the move is valid, taking into consideration the direction of travel, return it,
      // otherwise return nil
      if proposedMove.rowMovement == 2 && proposedMove.piece.color == homeColor {
        return validMove ? proposedMove : nil
      } else if proposedMove.rowMovement == -2 && proposedMove.piece.color != homeColor {
        return validMove ? proposedMove : nil
      } else {
        return nil
      }
    }
    
    // If the row movement magnitude is 1, this is a normal 1 step forward movement
    else if rowMovementMagnitude == 1 && columnMovementMagnitude == 0 {
      // Setting a boolean validMove to whether or not the move is valid
      let validMove =
      board[proposedMove.destination.column][proposedMove.destination.row].piece == nil
      
      // If the move is valid, taking into account direction of travel, return it
      // otherwise return nil
      if proposedMove.rowMovement > 0 && proposedMove.piece.color == homeColor {
        return validMove ? proposedMove : nil
      } else if proposedMove.rowMovement < 0 && proposedMove.piece.color != homeColor {
        return validMove ? proposedMove : nil
      } else {
        return nil
      }
    }
    
    // None of the possible moves were used, return a nil ChessMove
    else { return nil }
  }
  
  // Checking if the piece that can be captured en passant is valid to be captured as such
  func validCaptureForEnPassant(piece: RCChessPiece) -> Bool {
    // The piece needs to be a pawn that has only moved once
    if piece.type == .Pawn && piece.moveHistory.count == 1 {
      // Getting the last move of the piece
      let lastMove = piece.moveHistory[0]
      
      // The last piece was a two forward pawn move
      if abs(lastMove.rowMovement) == 2 && lastMove.columnMovement == 0 {
        return true
      } else {
        return false
      }
    } else {
      return false
    }
  }
  
  // Specific function to determine if a rook move is legal
  func verifyRookMove(proposedMove: RCChessMove) -> RCChessMove? {
    // One and only one coordinate of the move must be zero for a legal rook move
    if (proposedMove.columnMovement == 0) != (proposedMove.rowMovement == 0) {
      // Verifying the movement, returning nil if it is not valid
      return verifyMovementPath(proposedMove.start, destination: proposedMove.destination) ?
      proposedMove : nil
    } else {
      // The move is not valid, return a nil ChessMove
      return nil
    }
  }
  
  // Specific function to determine if a knight move is legal
  func verifyKnightMove(proposedMove: RCChessMove) -> RCChessMove? {
    // Getting the absolute value of the proposed move's x and y
    let columnMovementMagnitude = abs(proposedMove.columnMovement)
    let rowMovementMagnitude = abs(proposedMove.rowMovement)
    
    // Two xor statements make sure one of the movements coordinate movements has a magnitude of two
    // and one of the coordinate movements has a magnitude of 1
    if (columnMovementMagnitude == 2) != (rowMovementMagnitude == 2) &&
      (columnMovementMagnitude == 1) != (rowMovementMagnitude == 1) {
      // Get the destination square according to the destination coordinates
      let destinationSquare = board[proposedMove.destination.column][proposedMove.destination.row]
        
      // If there is a piece at the destination, make sure it is not the same color as the moving 
      // piece
      if let destinationPiece = destinationSquare.piece {
        // The move is valid only if the piece in the destination square is not the same color as
        // the moving piece
        return destinationPiece.color != proposedMove.piece.color ? proposedMove : nil
      } else {
        // The move is valid, there is no piece in the destination square
        return proposedMove
      }
    } else {
      // The move is not valid because it does not have the proper coordinates
      return nil
    }
  }
  
  // Specific function to determine if a bishop move is legal
  func verifyBishopMove(proposedMove: RCChessMove) -> RCChessMove? {
    // Getting the absolute value of the proposed move's x and y
    let columnMovementMagnitude = abs(proposedMove.columnMovement)
    let rowMovementMagnitude = abs(proposedMove.rowMovement)
    
    // If the positive versions are equal the move is indeed diagonal as required for bishops
    if columnMovementMagnitude == rowMovementMagnitude {
      // Verifying the movement, if it is valid, return the proposed move, otherwise return nil
      return verifyMovementPath(proposedMove.start, destination: proposedMove.destination) ?
      proposedMove : nil
    } else {
      // The magnitudes of the column and row movements are not the same so the movement is not
      // diagonal and thus the move is not valid
      return nil
    }
  }
  
  // Specific function to determine if a queen move is legal
  func verifyQueenMove(proposedMove: RCChessMove) -> RCChessMove? {
    // Verify movement path returns false if the move is not diagonal or straight, so thus the queen
    // can send moves directly for verification.  If the verification is successful, return the move
    // otherwise return nil
    return verifyMovementPath(proposedMove.start, destination: proposedMove.destination) ?
      proposedMove : nil
  }
  
  // Specific function to determine if a king move is legal
  func verifyKingMove(proposedMove: RCChessMove) -> RCChessMove? {
    // Getting the absolute value of the proposed move's x and y
    let columnMovementMagnitude = abs(proposedMove.columnMovement)
    let rowMovementMagnitude = abs(proposedMove.rowMovement)
    
    // The king only has a range of one
    if columnMovementMagnitude <= 1 && rowMovementMagnitude <= 1 {
      // Verifying the movement, if it is legal, return the proposed move, otherwise return nil
      if verifyMovementPath(proposedMove.start, destination: proposedMove.destination) {
        proposedMove.flag = .kingMove
        return proposedMove
      } else {
        return nil
      }
    } else if columnMovementMagnitude == 2 && rowMovementMagnitude == 0 &&
      !proposedMove.piece.moved {
      // Checking to see if a castle is possible
      // Setting up the rook's destination
      let rookDestinationColumn = proposedMove.start.column + (proposedMove.columnMovement / 2)
      let rookDestination =
        RCChessCoordinate(column: rookDestinationColumn, row: proposedMove.start.row)
        
      // Two different scenarios, castling right or castling left
      if proposedMove.columnMovement > 0 {
        // Castling to the right, rook will be at column 7
        let rookStart = RCChessCoordinate(column: 7, row: proposedMove.start.row)
        
        // Checking to see if a piece actually exists where the rook should be
        if let piece = board[rookStart.column][rookStart.row].piece {
          // If the piece at column 7 has not been moved then it is indeed a rook and is eligible
          // for castling.  Thus, set legal as a constant indicating whether the castle is possible
          // or not
          let legal = !piece.moved && verifyMovementPath(rookStart, destination: rookDestination)
          
          // Set the flag for castle and return the move if the move is legal, otherwise return nil
          if legal {
            proposedMove.flag = .castle
            return proposedMove
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
        let rookStart = RCChessCoordinate(column: 0, row: proposedMove.start.row)
        
        // Checking to see if a piece actually exists where the rook should be
        if let piece = board[rookStart.column][rookStart.row].piece {
          // If the piece at column 0 has not been moved then it is indeed a rook and is eligible
          // for castling.  Thus, set legal as a constant indicating whether the castle is possible
          // or not
          let legal = !piece.moved && verifyMovementPath(rookStart, destination: rookDestination)
          
          // Set the flag for castle and return the move if the move is legal, otherwise return nil
          if legal {
            proposedMove.flag = .castle
            return proposedMove
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
  
  // PATH VERIFICATION HANDLING //
  
  // The path a move requires will be verified by iterating through all of the squares in a path
  // and making sure no squares have pieces that block the path.  Additionally, the destination
  // square will be analized to make sure that if it has a piece to be captured, that piece is of a
  // different color from the piece that is making the move.
  
  // Function to set up and dispatch iterations to verify that the path the move needs to make is
  // a valid path, will dispatch to sub functions for different path types
  func verifyMovementPath(start: RCChessCoordinate, destination: RCChessCoordinate) -> Bool {
    let direction = pathDirection(start, destination: destination)
    return verifyPath(start: start, destination: destination, direction: direction)
  }
  
  // Simple enumeration to detail the different cases of path directions that are possible from the
  // movements of the pieces
  enum RCPathDirection {
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
  func pathDirection(start: RCChessCoordinate, destination: RCChessCoordinate) -> RCPathDirection {
    // Getting the row and column differences
    var rowDifference = destination.row - start.row
    var columnDifference = destination.column - start.column
    
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
  func verifyPath(#start: RCChessCoordinate, destination: RCChessCoordinate,
    direction: RCPathDirection) -> Bool {
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
      destination: destination)
  }
  
  // Function that actually iterates through the chess squares and verifies that the move can be 
  // made
  func verifyPath(columnIncrement: Int, rowIncrement: Int, start: RCChessCoordinate,
    destination: RCChessCoordinate) -> Bool {
    // Setting up the iterator values for the column and row
    var iteratorColumn = start.column, iteratorRow = start.row
      
    // Saving the start position to compare pieces later
    let startSquare = board[iteratorColumn][iteratorRow]
      
    // Iterating through all of the areas between the start column and the destination column to
      // make sure there are no pieces there
    while iteratorColumn != (destination.column - columnIncrement) ||
      iteratorRow != (destination.row - rowIncrement) {
      iteratorColumn += columnIncrement
      iteratorRow += rowIncrement
      if board[iteratorColumn][iteratorRow].piece != nil {
        return false
      }
    }
    
    // Checks to make sure theres a mismatch between the moving piece and the possible piece at the
    // destination having already successfully made sure there were no pieces in between them
    if let destinationPiece = board[destination.column][destination.row].piece {
      return destinationPiece.color != startSquare.piece?.color
    } else {
      return true
    }
  }
  
  
  // MOVE HANDLING //
  
  
  // The performMove function will look at the flags in the given move that is passed to it and
  // perform the move according to how it should be done.  If a move is special, it will need to be
  // handled differently from the rest of the moves that are possible.
  
  // Function to perform a given move
  func performMove(moveToPerform: RCChessMove) {
    // Saving the move to the piece's move history
    moveToPerform.piece.moveHistory.append(moveToPerform)
    
    // Switching the flag to take care of the different special moves that may be being performed
    switch moveToPerform.flag {
      // Specific movement for taking care of en passant captures
      case .enPassant:
        // Setting up the coordinate of the enpassant piece to be removed
        let enPassantRemoval = RCChessCoordinate(column: moveToPerform.destination.column,
          row: moveToPerform.start.row)
        
        // Removing the piece and putting the moving piece in its destination location
        removePieceAt(enPassantRemoval)
        board[moveToPerform.destination.column][moveToPerform.destination.row].piece =
          moveToPerform.piece
        board[moveToPerform.start.column][moveToPerform.start.row].piece = nil
      
      // Specific movement for taking care of castling
      case .castle:
        let rook: RCChessPiece!
        if moveToPerform.columnMovement > 0 {
          // Castling right, rook is at column 7, remove it
          rook = board[7][moveToPerform.start.row].piece!
          board[7][moveToPerform.start.row].piece = nil
        } else {
          // Castling left, rook is at column 0, remove it
          rook = board[0][moveToPerform.start.row].piece!
          board[0][moveToPerform.start.row].piece = nil
        }
        
        // Moving the king to its new location and placing the rook in its new location
        let king = board[moveToPerform.start.column][moveToPerform.start.row].piece!
        board[moveToPerform.start.column][moveToPerform.start.row].piece = nil
        let newRookColumn = moveToPerform.start.column + (moveToPerform.columnMovement / 2)
        board[newRookColumn][moveToPerform.start.row].piece = rook
        board[moveToPerform.destination.column][moveToPerform.destination.row].piece = king
      
        switch (king.color) {
          case .White: whiteKingCoordinate = moveToPerform.destination
          case .Black: blackKingCoordinate = moveToPerform.destination
          default: break
        }
      
      case .kingMove:
        // Removing the piece and putting the moving piece in its destination location
        removePieceAt(moveToPerform.destination)
        board[moveToPerform.destination.column][moveToPerform.destination.row].piece =
          moveToPerform.piece
        board[moveToPerform.start.column][moveToPerform.start.row].piece = nil
      
        switch (moveToPerform.piece.color) {
          case .White: whiteKingCoordinate = moveToPerform.destination
          case .Black: blackKingCoordinate = moveToPerform.destination
          default: break
        }
      
      // All other moves
      case .none:
        // Removing the piece and putting the moving piece in its destination location
        removePieceAt(moveToPerform.destination)
        board[moveToPerform.destination.column][moveToPerform.destination.row].piece =
          moveToPerform.piece
        board[moveToPerform.start.column][moveToPerform.start.row].piece = nil
    }
  }
  
  // Function to remove the piece at a given square and put it into the removed pieces arrays 
  // depending on its color
  func removePieceAt(coordinate: RCChessCoordinate) {
    var square = board[coordinate.column][coordinate.row]
    if let removedPiece = square.piece {
      if removedPiece.color == .Black {
        whiteCapturedPieces.append(removedPiece)
      } else if removedPiece.color == .White {
        blackCapturedPieces.append(removedPiece)
      }
      board[coordinate.column][coordinate.row].piece = nil
    }
  }
  
  func performKingCheckTest(moveToPerform: RCChessMove)
    -> Bool {
      // Perfrom the move and check whether the king is in check after the move
      var testBoard = RCChessBoard(board: board)
      if let validMove = verifyMove(moveToPerform) {
        testBoard.performMove(moveToPerform)
      }
      let check = testBoard.isKingInCheck(moveToPerform.piece.color)
      return check
  }
  
  func isKingInCheck(color: RCPieceColor) -> Bool {
    var kingSquare: RCChessSquare!
    
    // Finding the chess square containing the king from the saved and updated coordinates
    switch color {
      case .White: kingSquare = board[whiteKingCoordinate.column][whiteKingCoordinate.row]
      case .Black: kingSquare = board[blackKingCoordinate.column][blackKingCoordinate.row]
      case .Undefined: kingSquare = RCChessSquare()
    }
    
    // Iterating through all of the opponent pieces and seeing if there is a valid attack move for
    // them to do, which would mean that the king is in check
    for squareLine in board {
      for square in squareLine {
        if let potentialAttackingPiece = square.piece {
          if (potentialAttackingPiece.color != color) {
            let move = RCChessMove(start: square.coordinate, destination: kingSquare.coordinate,
              piece: potentialAttackingPiece)
            if verifyMove(move) != nil {
              return true
            } else {
              continue
            }
          } else {
            continue
          }
        } else {
          continue
        }
      }
    }
    // If no check is found
    return false
  }
  
  func flipBoard() {
    switch(homeColor) {
      case .White: homeColor = .Black
      case .Black: homeColor = .White
      default: break
    }
    
    for var i = 0; i < 8; ++i {
      if i < 4 {
        // Flipping all of the columns in the board
        var temp = board[i]
        board[i] = board[7-i]
        board[7-i] = temp
      }
      for var j = 0; j < 4; ++j {
        // Flipping the rows
        var temp = board[i][j]
        board[i][j] = board[i][7 - j]
        board[i][7 - j] = temp
        
        // Assigning new coordinates to the squares
        board[i][7 - j].coordinate.row = 7 - j
        board[i][7 - j].coordinate.column = i
        board[i][j].coordinate.row = j
        board[i][j].coordinate.column = i
      }
    }
    
    blackKingCoordinate.row = 7 - blackKingCoordinate.row
    whiteKingCoordinate.row = 7 - whiteKingCoordinate.row
    blackKingCoordinate.column = 7 - blackKingCoordinate.column
    whiteKingCoordinate.column = 7 - whiteKingCoordinate.column
  }
  
  func findKing(board: [[RCChessSquare]], color: RCPieceColor) -> RCChessCoordinate {
    for column in board {
      for square in column {
        if let piece = square.piece {
          if piece.type == .King && piece.color == color { return square.coordinate }
        }
      }
    }
    return RCChessCoordinate()
  }
  
  func testForCheckMate(color: RCPieceColor) -> Bool {
    for column in board {
      for square in column {
        if let piece = square.piece {
          if piece.color == color {
            if escapePossibleViaMoveFrom(square) {
              return false
            }
          }
        }
      }
    }
    
    return true
  }
  
  func escapePossibleViaMoveFrom(testingSquare: RCChessSquare) -> Bool {
    for column in board {
      for square in column {
        var move = RCChessMove(start: testingSquare.coordinate, destination: square.coordinate,
          piece: testingSquare.piece!)
        if !performKingCheckTest(move) {
          return true
        }
      }
    }
    return false
  }
}