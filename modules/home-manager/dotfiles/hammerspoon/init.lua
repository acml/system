-- install hammerspoon cli
local brewPrefixOutput, _, _, _ = hs.execute("brew --prefix", true)
local brewPrefix = string.gsub(brewPrefixOutput, "%s+", "")
require("hs.ipc")
local ipc = hs.ipc.cliInstall(brewPrefix)
print(string.format("ipc: %s", ipc))

-- Make all our animations really fast
hs.window.animationDuration = 0

-- Load SpoonInstall, so we can easily load our other Spoons
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true
Install = spoon.SpoonInstall

-- Draw pretty rounded corners on all screens
Install:andUse("RoundedCorners", {
    start = true,
    config = {
        radius = 12,
    },
})

-- use as a replacement for ReloadConfiguration for now
hs.hotkey.bind({ "cmd", "ctrl", "shift" }, "r", function()
    hs.reload()
end)

function openEmacs()
    os.execute('/etc/profiles/per-user/ahmet/bin/zsh -c emacs&', true)
end

function openEmacsClient()
    os.execute('/etc/profiles/per-user/ahmet/bin/zsh -c -- "/etc/profiles/per-user/ahmet/bin/emacsclient -n -c -a \"\""&', true)
end

hs.hotkey.bind({ "cmd" }, hs.keycodes.map["return"], function() os.execute("/etc/profiles/per-user/ahmet/bin/wezterm&") end)
hs.hotkey.bind({ "cmd", "alt" }, hs.keycodes.map["return"], openEmacs)
hs.hotkey.bind({ "cmd", "shift", "alt" }, hs.keycodes.map["return"], openEmacsClient)

-- quick launch text editor
-- hs.hotkey.bind(
--     {"cmd", "alt"},
--     hs.keycodes.map["return"],
--     function()
--         hs.notify.new(
--             {title = "Starting editor", informativeText = "Just give it a moment while we pick the best editor"}
--         ):send()
--         customshellrun.run("emacsclient -a '' --no-wait -c", true)
--     end
-- )

-- Provides a keyboard based window switcher (instead of app switcher)
hs.hotkey.bind({"alt"}, "tab", function() hs.hints.windowHints() end)

-- hs.hotkey.bind(modifiers.hyper, "i",
--     function() hs.task.new("@myEmacs@/bin/emacsclient", nil, function() return false end,
--             { "-a", "", "--eval", "(emacs-everywhere)" }):start()
--     end)
-- TODO: why is this infinitely reloading?
-- Install:andUse("ReloadConfiguration", {
--     start = true,
--     hotKeys = {
--         reloadConfiguration = { { "cmd", "ctrl", "shift" }, "r" },
--     },
-- })

Install:andUse("Caffeine", {
    start = true,
})

-- import keybindings for yabai
yabai = require("yabai")
caps2esc = require("caps2esc")
