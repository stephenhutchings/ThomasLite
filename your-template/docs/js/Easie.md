### Easie

Easing functions by [J. Jeffers](https://github.com/jimjeffers/Easie), ported from [Robert Penner's Easing Equations in CoffeeScript](http://robertpenner.com/easing/).

```coffee
Easie = require("lib/easie")
```

The following methods are available:

```coffee
backIn(time, begin, change, duration, overshoot = 1.70158)
backOut(time, begin, change, duration, overshoot = 1.70158)
backInOut(time, begin, change, duration, overshoot = 1.70158)

bounceOut(time, begin, change, duration)
bounceIn(time, begin, change, duration)
bounceInOut(time, begin, change, duration)

circIn(time, begin, change, duration)
circOut(time, begin, change, duration)
circInOut(time, begin, change, duration)

cubicIn(time, begin, change, duration)
cubicOut(time, begin, change, duration)
cubicInOut(time, begin, change, duration)

elasticOut(time, begin, change, duration, amplitude = null, period = null)
elasticIn(time, begin, change, duration, amplitude = null, period = null)
elasticInOut(time, begin, change, duration, amplitude = null, period = null)

expoIn(time, begin, change, duration)
expoOut(time, begin, change, duration)
expoInOut(time, begin, change, duration)

linearNone(time, begin, change, duration)
linearIn(time, begin, change, duration)
linearOut(time, begin, change, duration)
linearInOut(time, begin, change, duration)

quadIn(time, begin, change, duration)
quadOut(time, begin, change, duration)
quadInOut(time, begin, change, duration)

quartIn(time, begin, change, duration)
quartOut(time, begin, change, duration)
quartInOut(time, begin, change, duration)

quintIn(time, begin, change, duration)
quintOut(time, begin, change, duration)
quintInOut(time, begin, change, duration)

sineIn(time, begin, change, duration)
sineOut(time, begin, change, duration)
sineInOut(time, begin, change, duration)
```
