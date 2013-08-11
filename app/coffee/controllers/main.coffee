app.controller 'MainCtrl', ($scope, T3Factory, $location, $routeParams) ->

  ## Watch for ultimate winner
  $scope.$watch 'game', () ->
    if $scope.game?.started is 'started'
      $scope.game.winner = checkUltimateWinner($scope.game)
      $scope.game.status = "Player #{$scope.game.winner} is the ultimate winner!" if $scope.game.winner

      # Check for tie game
      if not $scope.game.winner and fullBoard($scope.game)
        $scope.game.tie = true
        $scope.game.status = "OMG -- It's a tie!"

  , true

  ## Constructor for a new game
  newGame = () ->
    game =
      turn: 1
      winner: false
      started: 'started'
      board_turn: -1
      status: 'Player 1 to start the game!'

    # Initialize all subgames
    for i in [0..8]
      game["board#{i}"] =
        board: (false for x in [0..8])
        winner: false

    game


  ## Local game
  # ------------------

  if $routeParams.game is 'local'
    # Initialize main game
    $scope.game = newGame()
    $scope.game.local = true

  ## Online game
  # ------------------

  else
    $scope.gameURL = $location.absUrl()

    # Link up angularFire, which returns a promise
    promise = T3Factory.link $scope, 'game', {}, $routeParams.game

    promise.then () ->

      game = $scope.game

      ## Initialization
      ## ------------

      # Attach onDisconnect event
      # ------------
      ref = new Firebase 'https://3t.firebaseio.com/' + $routeParams.game

      # Connecting to pending game
      # ------------
      if game.started == 'pending'
        console.log 'Connecting to the game!'
        localStorage.player = 2
        ref.onDisconnect().set null

        # Initialize main game
        $scope.game = newGame()

      # Initialize new game
      # --------------
      else if game.started is undefined
        console.log 'Created new game'
        localStorage.player = 1
        ref.onDisconnect().set null
        $scope.game =
          started: 'pending'

      # Spectator mode
      # ----------------
      else if game.started == 'started'
        console.log 'Spectating?'
        localStorage.player = 3
        alert("game already started! Just a spectator...")

  ## Utils
  ## ------------

  # True for the user who matched a waiting online player (Challenge accepted)
  $scope.starting = () ->
    localStorage.starting

  $scope.is_pending = () ->
    $scope.game?.started is 'pending'

  $scope.has_started = () ->
    $scope.game?.started is 'started'

  $scope.your_turn = () ->
    return true if localStorage.local # Always your turn if local
    $scope.game.turn?.toString() == localStorage.player

  $scope.rematch = () ->
    $scope.game = newGame()

  $scope.homepage = () ->
    $scope.game = null
    $location.path "/"

  fullBoard = (game) ->
    [0..8].every (i) ->
      board = game["board#{i}"]
      return board.winner or board.tie

  checkUltimateWinner = (game) ->
    checkWinRow(game.board0.winner, game.board1.winner, game.board2.winner) or
    checkWinRow(game.board3.winner, game.board4.winner, game.board5.winner) or
    checkWinRow(game.board6.winner, game.board7.winner, game.board8.winner) or
    checkWinRow(game.board0.winner, game.board3.winner, game.board6.winner) or
    checkWinRow(game.board1.winner, game.board4.winner, game.board7.winner) or
    checkWinRow(game.board2.winner, game.board5.winner, game.board8.winner) or
    checkWinRow(game.board0.winner, game.board4.winner, game.board8.winner) or
    checkWinRow(game.board2.winner, game.board4.winner, game.board6.winner)

  checkWinRow = (a,b,c) ->
    if a is b is c then a unless a is 0
