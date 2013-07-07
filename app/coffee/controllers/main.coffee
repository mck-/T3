app.controller 'MainCtrl', ($scope, T3Factory, $location, $routeParams) ->

  $scope.gameURL = $location.absUrl()

  localStorage.removeItem('player')

  # Link up angularFire, which returns a promise
  promise = T3Factory.link $scope, 'game', {}, $routeParams.game

  promise.then (game) ->

    console.log game

  ## Initialization
  ## ------------
    $scope.has_started = () ->
      $scope.game.started is 'started'

    $scope.newOnlineGame = () ->
      $scope.game =
        started: 'pending'
      console.log 'initialized new game'
      localStorage.player = 1

    $scope.newBoard = () ->
      $scope.game =
        board: (x = [false,false,false] for x in [false,false,false])
        turn: 1
        winner: false
        started: 'started'

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
      if $scope.game.turn.toString() == localStorage.player
        unless $scope.game.board[row]?[col] or $scope.game.winner
          $scope.game.board[row]?[col] = $scope.game.turn
          $scope.game.turn = if $scope.game.turn is 1 then 2 else 1

  # Define logic in the promise
    $scope.$watch 'game.board', () ->
      $scope.game.winner = checkWinner($scope.game.board) if $scope.game.board
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

  ## ------------