Connect = require '../helpers/Connect'
Star = require '../components/Star'

module.exports = Connect createReactClass(
  toggleActive: ()->
    @props.toggleActive(if @props.status == 'inactive' then 'active' else 'inactive')
    sleep = (ms) ->
      new Promise (resolve) ->
        window.setTimeout resolve, ms

    say = (text) ->
      window.speechSynthesis.cancel()
      window.speechSynthesis.speak new SpeechSynthesisUtterance text

    countdown = (seconds) ->
      for i in [seconds..1]
        say i
        await sleep 1000 # wait one second
      say "Blastoff!"

    countdown 3

  render: ->
    renderStarRating = ({ rating , maxStars }) ->
      <aside title={"Rating: #{rating} of #{maxStars} stars"}>
        {for wholeStar in [0...Math.floor(rating)]
          <Star className="wholeStar" key={wholeStar} />}
        {if rating % 1 isnt 0
          <Star className="halfStar" />}
        {for emptyStar in [Math.ceil(rating)...maxStars]
          <Star className="emptyStar" key={emptyStar} />}
      </aside>

    <div>
      <h1 onClick={@toggleActive}>Some {'fancy'} interpolation here {3 + 8}</h1>

      {for i in [0...30]
        <div key={i}>{renderStarRating(rating: 5, maxStars: 100)}</div>
      }
    </div>
), {
  state: (state)->
    status: state.app.status
  dispatch: (dispatch)->
    toggleActive: (payload)-> dispatch(type: 'SOME_ACTION', payload: payload)
}