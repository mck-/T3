app.directive 'ttt', () ->
  scope:
    subgame: '='
    game: '='
    bid: '@'
  restrict: 'E'
  templateUrl: '../views/board.html'
  link: (scope, element, attrs) ->

    ## Game utils
    ## ------------
    scope.your_turn = () ->
      return true if localStorage.local # Always your turn if local
      scope.game.turn.toString() == localStorage.player

    scope.toggle_turn = () ->
      scope.game.turn = if scope.game.turn is 1 then 2 else 1

    scope.toggle_board_turn = (square) ->
      if fullBoard(scope.game["board#{square}"].board)
        scope.game.board_turn = -1
      else
        scope.game.board_turn = square

    scope.playable = () ->
      scope.game.board_turn is -1 or scope.game.board_turn?.toString() is scope.bid

    ## Game logic
    ## ------------

    scope.move = (square) ->
      if scope.your_turn() and scope.playable()
        unless scope.subgame.board[square]
          scope.subgame.board[square] = scope.game.turn
          scope.toggle_turn()
          scope.toggle_board_turn(square)

    scope.$watch 'subgame.board', () ->
      scope.subgame.winner = checkWinner(scope.subgame.board)
      if not scope.subgame.winner and fullBoard(scope.subgame.board) then scope.subgame.tie = true
    , true

  ## --------------
    fullBoard = (board) ->
      board?.every (square) ->
        square

    checkWinner = (board) ->
      checkWinRow(board[0], board[1], board[2]) or
      checkWinRow(board[3], board[4], board[5]) or
      checkWinRow(board[6], board[7], board[8]) or
      checkWinRow(board[0], board[3], board[6]) or
      checkWinRow(board[1], board[4], board[7]) or
      checkWinRow(board[2], board[5], board[8]) or
      checkWinRow(board[0], board[4], board[8]) or
      checkWinRow(board[2], board[4], board[6])

    checkWinRow = (a,b,c) ->
      if a is b is c then a unless a is 0

  ## ------------
