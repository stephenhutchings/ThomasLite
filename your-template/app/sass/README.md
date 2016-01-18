## FIT Content Engine SASS

Sass files should be kept to a rigid structure to ensure styles are optimised for clarity, performance and reusability.

The main structure is as follows:

```
app.engine.sass      # Used for engine content, it includes base styles,
                     # template styles and other UI components. Its content
                     # is too specific to be included in generic
                     # presentations.


app.custom.sass      # Used for standard presentations, it includes base
                     # styles and imports slides

/core                # Configure global style attributes
   _vars.sass
   _fonts.sass
   _reset.sass

/components          # For reusable components, such as typography,
                     # transitions, grids, blocks, pagination etc.

/engine              # For engine specific styles that won't be reusable
                     # in new presentations.

/slides              # For custom slide specific styles. This directory is
                     # where generated slides styles will be placed.

/views               # For containing views, like MainView and SlidesView.

```
