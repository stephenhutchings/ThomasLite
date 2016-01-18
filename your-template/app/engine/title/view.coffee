# SlideView provides a lot of boilerplate, and is the super-class of all slides
SlideView = require("views/slide")

class TitleView extends SlideView

  # This returns the compiled Jade template for
  template: require("./template")

  # This slide does two things: it can go to the next slide or exit the lesson,
  # depending on which button is pressed. We listen to the "iostap" event,
  # not click or tap. The `next` and `exit` methods are declared in SlideView.
  events:
    "iostap .btn-next": "next"
    "iostap .btn-exit": "exit"

module.exports = TitleView
