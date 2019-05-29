local gears = require("gears")
local naughty = require("naughty")
require("socket")
local socket_unix = require("socket.unix")


local notify = {}

function notify.watch(args)
  args = args or {}
  local socket_name = args.socket_filename
  if not socket_name then
    local xdg_dir = os.getenv("XDG_RUNTIME_DIR")
    socket_name = xdg_dir .. "/yubikey-touch-detector.socket"
  end

  local socket = socket_unix()
  assert(socket:connect(socket_name))
  socket:settimeout(0)
  existing_notify = nil

  return gears.timer.start_new(
    args.timeout or 0.5,
    function()
      -- We always get 5 bytes, e.g. GPG_1, SSH_0
      data = socket:receive(5)

      if data then
        title = args.title or "Yubikey waiting on touch..."
        get_next_word = string.gmatch(data, "(%w+)")
        text = get_next_word()
        switch = get_next_word()

        if switch == "1" then
          existing_notify = naughty.notify({
            title = title,
            position = "top_middle",
            text = text,
            timeout = 0
          })
        else
          if existing_notify then
            naughty.destroy(existing_notify, naughty.notification_closed_reason.expired)
            existing_notify = nil
          else
            naughty.replace_text(existing_notify, title, text)
          end
        end
      end
      return true
    end
  )
end

return notify
