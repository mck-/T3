app.controller 'MainCtrl', ($scope, T3Factory, $location, $routeParams, $timeout) ->

  $scope.gameURL = $location.absUrl()
  console.log 'Main Ctrl initialized'

  # Link up angularFire, which returns a promise
  promise = T3Factory.link $scope, 'game', {}, $routeParams.game

  promise.then (game) ->

  ## Utils
  ## ------------
    $scope.has_started = () ->
      $scope.game.started is 'started'

    $scope.your_turn = () ->
      $scope.game.turn?.toString() == localStorage.player

  ## Initialization
  ## ------------

    $timeout $scope.game =
      board: (x = [false,false,false] for x in [false,false,false])
      turn: 1
      winner: false
      started: 'started'
    , 10

  ## Connecting to pending game
  ## ------------
    if game.started == 'pending'
      console.log 'Connecting!'
      localStorage.player = 2
      $scope.game =
        board: (x = [false,false,false] for x in [false,false,false])
        turn: 2
        winner: false
        started: 'started'

    if game.started == 'started'
      console.log 'Spectating?'
      localStorage.player = 3
      alert("game has started! Just a spectator...")

  ## Game logic
  ## ------------

    $scope.move = (row, col) ->
      if $scope.your_turn()
        unless $scope.game.board[row]?[col] or $scope.game.winner
          $scope.game.board[row]?[col] = $scope.game.turn
          $scope.game.turn = if $scope.game.turn is 1 then 2 else 1


    $scope.$watch 'game.board', () ->
      $scope.game.winner = checkWinner($scope.game.board) if $scope.game.board
      if not $scope.game.winner and fullBoard($scope.game.board) then $scope.game.tie = true
    , true

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
