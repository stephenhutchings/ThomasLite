### Preload

Loads an array on images concurrently, and fires callback when complete.

```coffee
Preload = require("lib/preload")
```

The callback is called with an array of image paths that resulted in an error or null. You can set the number of concurrent downloads and a maximum duration to wait before calling that callback.

```coffee
  Preload.load(all = [], callback, conc = 4, maxTime = 3000)
```
