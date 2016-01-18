### Grids

Thomas uses a 12-column grid system which is very similar to Bootstrap's implementation. There are column classes for small screens `-sm` under 600px and larger screens `-lg`.

```css
/* Small classes cascade to larger sizes */
.col-sm-1, .col-sm-2, .col-sm-3, .col-sm-4 ... .col-sm-12

/* Large classes have no effect on smaller screens */
.col-lg-1, .col-lg-2, .col-lg-3, .col-lg-4 ... .col-lg-12
```

The gutter is 20px for mobile screens, and either 36px or 64px for larger screens.

Wrap columns in a `.row` class to clear floats and provide a reverse margin for each columns padding.
