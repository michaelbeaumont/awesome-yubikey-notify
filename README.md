# Setup

Required:
* `lua-socket` library
* [`yubikey-touch-detector`](https://github.com/maximbaz/yubikey-touch-detector)

The most basic setup in `rc.lua`:

```lua
local yubikey_notify = require("awesome-yubikey-notify")

yubikey_notify.watch()
```

Icons can also be specified and one (adapted from FontAwesome) is provided with the library:

```lua
yubikey_notify.watch{
    icon = path_to_lib .. "/key.svg",
}
```

See `init.lua` for other options.
