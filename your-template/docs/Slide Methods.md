### Slide Methods

A slide template is a backbone view, with an events hash. It also inherits some basic methods:

```coffee
prev: ->          # Go to the previous slide
next: ->          # Go to the next slide
show: ->          # Do something when we go to the slide
hide: ->          # Do something when we leave the slide

beforeShow: ->    # Do something before we go to the slide
beforeHide: ->    # Do something before we leave the slide
afterShow:  ->    # Ensure the slide is rendered, then do something

exit: ->          # Exit the lesson
```

#### Transformations and transitions

Easily apply transforms and transitions to DOM elements with the `transformEl` and `transitionEl` methods.

```coffee
example: ->
  @transformEl element,
    x: 0
    y: 0
    scale: 0.5
    rotate: "10deg"
    opacity: 0.2
    transition: "all 300ms"

  @transitionEl element, "all 300ms"
```

#### Slide states

Keep track of mulitple states using `setState`. Use `@currentState[key]` to retrieve the current state for `key`.

```coffee
example: ->
  @setState("prompt")             # @el now has class "state-prompt"
  @setState("paused", "audio")    # @el now has class "audio-paused"
  @setState(null, "audio")        # @el no longer has class "audio-paused"
```

#### Performance

Save references to elements to reduce DOM queries. Vanilla JS is preferred, but Zepto is available as well.

```coffee
example: ->
  @setEl(@el.querySelector("#canvas"), "canvas")
  @getEl("canvas")
```

#### Data processing

Process and filter values in the model data before rendering the template.

```coffee
serialize: ->
  data = super
  data.newValue = true
  return data
```

#### Refresh and resize events

Handle orientation and data changes that require components to adjust themselves.

```coffee
onRefresh: ->
onResize: ->
```
