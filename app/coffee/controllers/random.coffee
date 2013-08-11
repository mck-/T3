app.controller 'RandomCtrl', ($scope, $location, $timeout) ->

  # Clear localstorage
  localStorage.removeItem('player')
  localStorage.removeItem('waiting')

  numRef = new Firebase 'https://3t.firebaseio.com/'
  numRef.on 'value', (data) ->
    $scope.$apply () ->
      $scope.num_games = (k for k,v of data.val()).length

  $scope.homepage = () ->
    fbRef.off 'value'
    fbRef.set null
    $location.path "/"

  # Use a single reference cell on FB
  # - If the cell is null, nobody is waiting, therefore user creates a number
  # - Because setting the number triggers a callback, use localStorage to indicate that you are player 1, and prevent playing against yourself
  # - The user who connects and sees the number on the first callback is player 2
  # - If the cell has a number, set the cell to null, and go to the room
  # - Setting the cell to null should trigger both players to go to the room

  gameId = 0 unless gameId # So player 1 remembers what room to go to

  fbRef = new Firebase 'https://3t.firebaseio.com/random'
  fbRef.on 'value', (x) ->
    # Second person to connect
    if x.val() and not localStorage.waiting
      console.log 'Second person connected'
      $location.path "/#{x.val()}"
      $scope.$apply()
      localStorage.removeItem('waiting')
      fbRef.off 'value'
      fbRef.set null
    else
      # First person to connect
      if not localStorage.waiting
        console.log 'First person connected'
        localStorage.waiting = true
        gameId = Math.floor Math.random() * 99999
        # In case person leaves
        fbRef.onDisconnect().set null
        fbRef.set gameId
      else
        if x.val()
          console.log "First person set gameId to #{gameId}"
        else # Second person set ref to null, so start the game!
          console.log "Match found! Let the games begin!"
          localStorage.removeItem('waiting')
          fbRef.off 'value'

          # Make sure the other person is connected first
          $timeout () ->
            $location.path "/#{gameId}"
          , 1500, true
