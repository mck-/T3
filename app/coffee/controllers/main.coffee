app.controller 'MainCtrl', ($scope, T3Factory, $location, $routeParams) ->

  ## Watch for ultimate winner
  $scope.$watch 'game', () ->
    $scope.game.winner = checkUltimateWinner($scope.game)
  , true

  ## Constructor for a new game
  newGame = () ->
    game =
      turn: 1
      winner: false
      started: 'started'

    # Initialize all subgames
    for i in [1..9]
      game["board#{i}"] =
        board: (x = [false,false,false] for x in [false,false,false])
        winner: false

    game


  ## Local game
  # ------------------

  if $routeParams.game is 'local'
    # Initialize main game
    $scope.game = newGame()

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

      # Connecting to pending game
      # ------------
      if game.started == 'pending'
        console.log 'Connecting to the game!'
        localStorage.player = 2

        # Initialize main game
        $scope.game = newGame()

      # Initialize new game
      # --------------
      else if game.started is undefined
        console.log 'Created new game'
        localStorage.player = 1
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
  $scope.has_started = () ->
    $scope.game.started is 'started'

  $scope.your_turn = () ->
    return true if localStorage.local # Always your turn if local
    $scope.turn?.toString() == localStorage.player

  $scope.rematch = () ->
    $scope.game = newGame()

  checkUltimateWinner = (game) ->
    checkWinRow(game.board1.winner, game.board2.winner, game.board3.winner) or
    checkWinRow(game.board4.winner, game.board5.winner, game.board6.winner) or
    checkWinRow(game.board7.winner, game.board8.winner, game.board9.winner) or
    checkWinRow(game.board1.winner, game.board4.winner, game.board7.winner) or
    checkWinRow(game.board2.winner, game.board5.winner, game.board8.winner) or
    checkWinRow(game.board3.winner, game.board6.winner, game.board9.winner) or
    checkWinRow(game.board1.winner, game.board5.winner, game.board9.winner) or
    checkWinRow(game.board3.winner, game.board5.winner, game.board7.winner)

  checkWinRow = (a,b,c) ->
    if a is b is c then a unless a is 0
