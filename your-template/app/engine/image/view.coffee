# SlideView provides a lot of boilerplate, and is the super-class of all slides
SlideView = require("views/slide")

class ImageSlideView extends SlideView
  template: require("./template")

  events:
    "iostap .img": "toggleCaption"
    "iostap .btn-done": "next"

  # The serialize method is your chance to filter data on it's way from the CMS
  # to the template. Do the heavy-lifting here rather than putting the logic
  # into the jade template.
  serialize: ->
    data = super

    data.backgroundColor = @backgroundColor =
      if @options.data.caption?.background
        @options.data.caption.background
      else if @options.data.lightbox
        "#222"
      else
        data.config?.colors?.background

    data

  # Load the image as soon as the view is instantiated.
  initialize: ->
    super
    @loadImage()

  # If the view needs to alter it's display before it is shown, this is where
  # to do it. The image view determines whether it should enter "lightbox mode"
  # and which color to use if it does based on the model data.
  beforeShow: ->
    lightboxColor =
      if @options.data.lightbox then @backgroundColor else "default"

    @el.classList.toggle "is-lightbox", @options.data.lightbox
    @el.classList.toggle "has-background", @options.data.caption?.background

    if @options.data.lightbox
      @trigger("lightbox", lightboxColor, true)
    else
      @trigger("lightbox", false)

    @setTextColor()

  # If the view needs to alter it's display before it leaves the screen, this
  # is where to do it. This template exits "lightbox mode" before it hides.
  beforeHide: ->
    @trigger("lightbox", false)

  # If the view needs to reset itself when it receives new data, do it here.
  # CMS input will call trigger this method as the user changes data.
  onRefresh: ->
    super
    @loadImage()
    @beforeShow()

  # Set the text color based on the background color. Figure out the color
  # darkness based on its RGB hex value, and set the text color to light or
  # dark as appropriate.
  setTextColor: ->
    isDark =
      if @options.data?.caption?.background?.match(/#/)
        num = @options.data.caption.background.slice(1)
        num = ("#{n}#{n}" for n in num).join("") if num.length is 3
        avg =
          (_
            .chain(num)
            .groupBy((e, i) ->
              Math.floor(i / 2)
            ).toArray().reduce((m, e) ->
              m + parseInt(e.join(""), 16)
            , 0)
          ) / 3

        @options.data.caption.background and avg < 180

      else
        true

    @el.style.color = if isDark then "" else "black"

  # Create an image and bind a listener to the images load event.
  loadImage: ->
    img = new Image()
    img.onload = => @onImageLoad()
    img.src = @options.data.url

  # Once the image is loaded, set it as a background image on ".img"
  onImageLoad: ->
    img = @el.querySelector(".img")
    img.style.backgroundImage = "url(\"#{@options.data.url}\")"
    img.style.backgroundSize = @options.data.size or "cover"
    window.setTimeout (-> img.classList.add("is-loaded")), 300

  # Toggle the "show-caption" class on the root element
  toggleCaption: ->
    @el.classList.toggle("show-caption")

module.exports = ImageSlideView
