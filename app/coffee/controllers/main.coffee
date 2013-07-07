app.controller 'MainCtrl', ($scope, T3Factory, $location, $routeParams) ->

  # Link up angularFire, which returns a promise
  promise = T3Factory.link $scope, 'game', {}, $routeParams.game

  promise.then (board) ->

    $scope.gameURL = $location.absUrl()

    $scope.reset = () ->
      $scope.game =
        board: (x = [false,false,false] for x in [false,false,false])
        turn: 1
        winner: false
        started: false

    $scope.move = (row, col) ->
      unless $scope.game.board[row]?[col] or $scope.game.winner
        $scope.game.board[row]?[col] = $scope.game.turn
        $scope.game.turn = if $scope.game.turn is 1 then 2 else 1

  # Define logic in the promise
    $scope.$watch 'game.board', () ->
      $scope.game.winner = checkWinner($scope.game.board)
    , true

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