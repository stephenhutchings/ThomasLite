### Device

Get information about the current device.

```coffee
Device = require("lib/device")
```

```coffee
Device.dpi  # pixel ratio of the device

Device.events =
  pointer:
    isTouch # is a touch screen
    start   # "touchstart" or "mousedown"
    move    # "touchmove" or "mousemove"
    end     # "touchend" or "mouseup"

  resize    # "orientationchange" or "resize"

Device.isSmallScreen() # true for screens under the css @media breakpoint
```
