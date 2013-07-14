app.controller 'MainCtrl', ($scope, T3Factory, $location, $routeParams) ->

  ## Local game
  # ------------------

  if $routeParams.game is 'local'
    $scope.game =
      board1:
        board: (x = [false,false,false] for x in [false,false,false])
        winner: false
      board2:
        board: (x = [false,false,false] for x in [false,false,false])
        winner: false
      turn: 1
      winner: false
      started: 'started'


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
        $scope.game =
          board: (x = [false,false,false] for x in [false,false,false])
          turn: 1
          winner: false
          started: 'started'

      else if game.started == 'started'
        console.log 'Spectating?'
        localStorage.player = 3
        alert("game already started! Just a spectator...")

      # Initialize new game
      # --------------
      else if game.started is undefined
        console.log 'Created new game'
        localStorage.player = 1
        $scope.game =
          started: 'pending'

  # Watch for winner
  $scope.$watch 'game', () ->
    $scope.winner = checkUltimateWinner($scope.game)
  , true

  ## Utils
  ## ------------
  $scope.has_started = () ->
    $scope.game.started is 'started'

  $scope.your_turn = () ->
    return true if localStorage.local # Always your turn if local
    $scope.turn?.toString() == localStorage.player

  checkUltimateWinner = (game) ->
    #todo
    $scope.game.winner = 1 if game.board1.winner
