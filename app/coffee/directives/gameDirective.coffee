app.directive 'ttt', () ->
  scope:
    subgame: '='
    turn: '='
    board_turn: '='
    board_id: '@'
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

    scope.playable = () ->
      scope.board_turn is 0 or scope.board_turn is scope.board_id

    ## Game logic
    ## ------------

    scope.move = (square) ->
      if scope.your_turn() and scope.playable()
        unless scope.subgame.board[square]
          scope.subgame.board[square] = scope.turn
          scope.toggle_turn()

    scope.$watch 'subgame.board', () ->
      scope.subgame.winner = checkWinner(scope.subgame.board)
      if not scope.subgame.winner and fullBoard(scope.subgame.board) then scope.subgame.tie = true
    , true

  ## --------------
    fullBoard = (board) ->
      board?.every (square) ->
        square

    checkWinner = (board) ->
      checkWinRow(board[1], board[2], board[3]) or
      checkWinRow(board[4], board[5], board[6]) or
      checkWinRow(board[7], board[8], board[9]) or
      checkWinRow(board[1], board[4], board[7]) or
      checkWinRow(board[2], board[5], board[8]) or
      checkWinRow(board[3], board[6], board[9]) or
      checkWinRow(board[1], board[5], board[9]) or
      checkWinRow(board[3], board[5], board[7])

    checkWinRow = (a,b,c) ->
      if a is b is c then a unless a is 0

  ## ------------
