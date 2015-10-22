//
//  ChessBoard.swift
//  Chess
//
//  Created by Alexander Robau on 6/19/14.
//  Copyright (c) 2015 Robau Industries. All rights reserved.
//

import Foundation

protocol RCMoveDelegate {
  subscript(index: Int) -> [RCChessSquare] { get }
  func getHomeColor() -> RCPieceColor
}

class RCChessBoard: RCMoveDelegate {
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
  
  
  // CONFORMING TO RCMoveDelegate //
  
  
  // Subscript operator to return the chesssquare rows of the board
  subscript(index: Int) -> [RCChessSquare] {
    get {
      return board[index]
    }
  }
  
  // Function to get the home color according to the way the board is facing
  func getHomeColor() -> RCPieceColor {
    return homeColor
  }
  
  
  // MOVE VERIFICATION //
  
  
  // Function to verify the move passed to it by using the piece's moveVerifier to determine if the 
  // move is legal
  func verifyMove(move: RCChessMove) -> RCChessMove? {
    return move.piece.moveVerifier.verifyMove(move, moveDelegate: self)
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
      case .enPassant: performEnPassantMove(moveToPerform) // Specific for en passant captures
      case .castle: performCastle(moveToPerform) // Specific movement for taking care of castling
      case .kingMove: performKingMove(moveToPerform) // Move that will update the king coordinate
      case .none: performNormalMove(moveToPerform) // All other moves
    }
  }
  
  // Function to perform an enpassant move
  private func performEnPassantMove(moveToPerform: RCChessMove) {
    // Setting up the coordinate of the enpassant piece to be removed
    let enPassantRemoval = RCChessCoordinate(column: moveToPerform.destination.column,
      row: moveToPerform.start.row)
    
    // Removing the piece and putting the moving piece in its destination location
    removePieceAt(enPassantRemoval)
    board[moveToPerform.destination.column][moveToPerform.destination.row].piece =
      moveToPerform.piece
    board[moveToPerform.start.column][moveToPerform.start.row].piece = nil
  }
  
  // Function to perform a castle
  private func performCastle(moveToPerform: RCChessMove) {
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

  }
  
  // Function to perform a king move, updating the correct king coordinate
  private func performKingMove(moveToPerform: RCChessMove) {
    // Removing the piece and putting the moving piece in its destination location
    removePieceAt(moveToPerform.destination)
    board[moveToPerform.destination.column][moveToPerform.destination.row].piece =
      moveToPerform.piece
    board[moveToPerform.start.column][moveToPerform.start.row].piece = nil
    
    // Recording the new placement of the king in its proper king coordinate location
    switch (moveToPerform.piece.color) {
      case .White: whiteKingCoordinate = moveToPerform.destination
      case .Black: blackKingCoordinate = moveToPerform.destination
      default: break
    }
  }
  
  // Function to perform a normal move
  private func performNormalMove(moveToPerform: RCChessMove) {
    // Removing the piece and putting the moving piece in its destination location
    removePieceAt(moveToPerform.destination)
    board[moveToPerform.destination.column][moveToPerform.destination.row].piece =
      moveToPerform.piece
    board[moveToPerform.start.column][moveToPerform.start.row].piece = nil
  }
  
  // Function to remove the piece at a given square and put it into the removed pieces arrays
  // depending on its color
  func removePieceAt(coordinate: RCChessCoordinate) {
    let square = board[coordinate.column][coordinate.row]
    if let removedPiece = square.piece {
      if removedPiece.color == .Black {
        whiteCapturedPieces.append(removedPiece)
      } else if removedPiece.color == .White {
        blackCapturedPieces.append(removedPiece)
      }
      board[coordinate.column][coordinate.row].piece = nil
    }
  }
  
  
  // CHECK AND CHECKMATE HANDLING
  
  
  // Function to perform a move and then test for if the king will be in check
  func performKingCheckTest(moveToPerform: RCChessMove)
    -> Bool {
      // Perfrom the move and check whether the king is in check after the move
      let testBoard = RCChessBoard(board: board)
      if let validMove = verifyMove(moveToPerform) {
        testBoard.performMove(validMove)
      }
      let check = testBoard.isKingInCheck(moveToPerform.piece.color)
      return check
  }
  
  // Function to check if the given color king is in check
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
  
  // Function to flip the board in between turns
  func flipBoard() {
    switch(homeColor) {
      case .White: homeColor = .Black
      case .Black: homeColor = .White
      default: break
    }
    
    for var i = 0; i < 8; ++i {
      if i < 4 {
        // Flipping all of the columns in the board
        let temp = board[i]
        board[i] = board[7-i]
        board[7-i] = temp
      }
      for var j = 0; j < 4; ++j {
        // Flipping the rows
        let temp = board[i][j]
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
  
  // Function to find the king on the board
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
  
  // Function to test if the given color king is in checkmate, called on a color that is currently
  // in check
  func testForCheckMate(color: RCPieceColor) -> Bool {
    // iterating through all the columns and rows in the board
    for column in board {
      for square in column {
        if let piece = square.piece {
          // There is a piece in this space
          if piece.color == color {
            // The piece is the color we are checking for checkmate with
            if escapePossibleViaMoveFrom(square) {
              // If an escape from check is possible using this piece, return false because the king
              // is not in checkmate if escape is possible
              return false
            }
          }
        }
      }
    }
    // Iterated through entire board, and there is no way to escape the current check
    return true
  }
  
  // Function to determine if escape is possible from a given chesssquare
  func escapePossibleViaMoveFrom(testingSquare: RCChessSquare) -> Bool {
    // Iterating through all of the squares on the board to brute force find squares that could be
    // moved to
    for column in board {
      for square in column {
        // Creating a move that needs to be tested
        let move = RCChessMove(start: testingSquare.coordinate, destination: square.coordinate,
          piece: testingSquare.piece!)
        if !performKingCheckTest(move) {
          // If the king is no longer in check after moving, 
          // (using the performKingCheckTest function), the check is escapable using this move
          return true
        }
      }
    }
    // Iterated through all possible squares to move to, escape not possible.
    return false
  }
}