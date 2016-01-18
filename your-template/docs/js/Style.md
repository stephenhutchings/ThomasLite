### Style

Quickly apply CSS transforms and transitions with their vendor prefixes.

```coffee
Style = require("lib/style")
```

#### Transformations

Set transforms and an optional transition on an element. If x, y or rotate
values are numbers, append default units. Otherwise allow for passing
strings with different x, y values or units. Alternatively, pass a string
transform for a specific order of properties.

```coffee
transformEl(el, { x, y, z, scale, skew, rotate, transition, opacity })
transformEl(el, "translate3d(0, 0, 0)")
```

#### Transitions

Just set a transition on an element. Query the elements `offsetLeft` if
a DOM refresh is required to trigger subsequent animations.

```coffee
transitionEl(el, transition, triggerRefresh)
```
