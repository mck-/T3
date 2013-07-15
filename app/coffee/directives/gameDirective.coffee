app.directive 'ttt', () ->
  scope:
    subgame: '='
    turn: '='
  restrict: 'E'
  templateUrl: '../views/board.html'
  link: (scope, element, attrs) ->

    ## Game utils
    ## ------------

    scope.your_turn = () ->
      return true if localStorage.local # Always your turn if local
      scope.turn.toString() == localStorage.player

    scope.toggle_turn = () ->
      scope.turn = if scope.turn is 1 then 2 else 1

    ## Game logic
    ## ------------

    scope.move = (row, col) ->
      if scope.your_turn()
        unless scope.subgame.board[row]?[col]
          scope.subgame.board[row]?[col] = scope.turn
          scope.toggle_turn()

    scope.$watch 'subgame.board', () ->
      scope.subgame.winner = checkWinner(scope.subgame.board)
      if not scope.subgame.winner and fullBoard(scope.subgame.board) then scope.subgame.tie = true
    , true

  ## --------------
    fullBoard = (board) ->
      board?.every (row) ->
        row.every (square) ->
          square

    checkWinner = (board) ->
      checkWinRow(board[0]?[0], board[0]?[1], board[0]?[2]) or
      checkWinRow(board[1]?[0], board[1]?[1], board[1]?[2]) or
      checkWinRow(board[2]?[0], board[2]?[1], board[2]?[2]) or
      checkWinRow(board[0]?[0], board[1]?[0], board[2]?[0]) or
      checkWinRow(board[0]?[1], board[1]?[1], board[2]?[1]) or
      checkWinRow(board[0]?[2], board[1]?[2], board[2]?[2]) or
      checkWinRow(board[0]?[0], board[1]?[1], board[2]?[2]) or
      checkWinRow(board[0]?[2], board[1]?[1], board[2]?[0])

    checkWinRow = (a,b,c) ->
      if a is b is c then a unless a is 0

  ## ------------
