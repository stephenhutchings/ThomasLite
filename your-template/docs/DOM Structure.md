### DOM Structure

```jade
body
  #content
    //- Used to transition out content
    #outbound

    //- Contains current content
    #inbound

      //- The parent view (slides.jade)
      #slides-view

        //- The scroller element
        #slides-view-inner

          //- Contains information relating to the lesson
          #lesson-info

          #slides
            #slides-scroller
              .slide.slide-type-1
              .slide.slide-type-2
              //- etc.

          //-  Shows the content of the answer outside of the template
          #slide-answer

        //- Optional elements
        //- The top indicator
        #indicator
```
