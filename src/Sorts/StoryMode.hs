
module Sorts.StoryMode where


import Graphics.Qt

import Base


signs =
    "npcs/cpt-beaugard" :
    "npcs/high-school-girl-1" :
    "npcs/high-school-girl-2" :
    "npcs/high-school-girl-3" :
    "npcs/high-school-girl-4" :
    "npcs/monkey" :
    "npcs/bunny" :
    "data-terminal" :
    []

-- padding refers to upper left corner

tiles :: [(String, Position Int, Size Double, Seconds, Maybe [Int])]
tiles =
    ("tiles/black-blue/panel-standard", Position 1 1, Size 64 64, 1, Nothing) :
    ("tiles/black-blue/panel-small", Position 1 1, Size 32 32, 1, Nothing) :
    ("tiles/black-blue/panel-large", Position 1 1, Size 128 128, 1, Nothing) :
    ("tiles/black-blue/vent-large", Position 1 1, Size 128 128, 1, Nothing) :
    ("tiles/black-blue/vent-background-large", Position 1 1, Size 128 128, 1, Nothing) :
    ("tiles/black-blue/panel-arrows-left", Position 1 1, Size 64 128, 1, Nothing) :
    ("tiles/black-blue/panel-arrows-right", Position 1 1, Size 64 128, 1, Nothing) :
    ("tiles/black-blue/panel-arrows-up", Position 1 1, Size 128 64, 1, Nothing) :
    ("tiles/black-blue/panel-arrows-down", Position 1 1, Size 128 64, 1, Nothing) :
    ("tiles/black-blue/aircon-left", Position 1 1, Size 64 128, 1, Nothing) :
    ("tiles/black-blue/aircon-right", Position 1 1, Size 64 128, 1, Nothing) :
    ("tiles/black-blue/pilotlamp-standard-left", Position 9 1, Size 64 64, 0.3, Just [0, 0, 0, 1, 1]) :
    ("tiles/black-blue/pilotlamp-standard-right", Position 1 1, Size 64 64, 0.3, Just [0, 0, 0, 1, 1]) :
    ("tiles/black-blue/pilotlamp-small-left", Position 9 1, Size 32 32, 0.25, Just [0, 0, 0, 1, 1]) :
    ("tiles/black-blue/pilotlamp-small-right", Position 1 1, Size 32 32, 0.25, Just [0, 0, 0, 1, 1]) :
    ("tiles/black-blue/panel-light-pink", Position 1 1, Size 64 64, 0.4, Just [0, 1]) :
    ("tiles/black-blue/panel-light-yellow", Position 1 1, Size 64 64, 0.4, Just [0, 1]) :
    ("tiles/black-blue/panel-light-aqua", Position 1 1, Size 64 64, 0.4, Just [0, 1]) :
    ("tiles/black-blue/panel-light-red", Position 1 1, Size 64 64, 0.4, Just [0, 1]) :
    ("tiles/black-blue/panel-light-blue", Position 1 1, Size 64 64, 0.4, Just [0, 1]) :
    ("tiles/black-blue/panel-number-04", Position 1 1, Size 320 256, 1, Nothing) :
    ("tiles/black-blue/panel-number-06", Position 1 1, Size 320 256, 1, Nothing) :
    ("tiles/black-blue/panel-number-08", Position 1 1, Size 320 256, 1, Nothing) :
    ("tiles/black-blue/panel-number-09", Position 1 1, Size 320 256, 1, Nothing) :
    ("tiles/black-blue/wallpaper-standard", Position 1 1, Size 64 64, 1, Nothing) :
    ("tiles/black-blue/wallpaper-small", Position 1 1, Size 32 32, 1, Nothing) :
    ("tiles/black-blue/wallpaper-large-vent", Position 1 1, Size 128 128, 1, Nothing) :
    ("tiles/black-blue/wallpaper-number-01", Position 1 1, Size 328 264, 1, Nothing) :
    ("tiles/black-blue/wallpaper-number-02", Position 1 1, Size 328 264, 1, Nothing) :
    ("tiles/black-blue/wallpaper-number-03", Position 1 1, Size 328 264, 1, Nothing) :
    ("tiles/black-blue/wallpaper-number-05", Position 1 1, Size 328 264, 1, Nothing) :
    ("tiles/black-blue/wallpaper-number-07", Position 1 1, Size 328 264, 1, Nothing) :
    ("tiles/black-blue/wallpaper-number-10", Position 1 1, Size 328 264, 1, Nothing) :
    ("tiles/black-blue/terminal-standard-indoor", Position 5 5, Size 192 192, 1, Nothing) :
    ("tiles/black-blue/terminal-standard-outdoor", Position 1 1, Size 192 192, 1, Nothing) :
    ("tiles/black-blue/terminal-data-indoor", Position 5 5, Size 128 192, 1, Nothing) :
    ("tiles/black-blue/terminal-data-outdoor", Position 1 1, Size 128 192, 1, Nothing) :
    ("tiles/black-blue/shadow-standard", Position 1 1, Size 32 64, 1, Nothing) :
    ("tiles/black-green/panel-standard", Position 1 1, Size 64 64, 1, Nothing) :
    ("tiles/black-green/panel-small", Position 1 1, Size 32 32, 1, Nothing) :
    ("tiles/black-green/panel-large", Position 1 1, Size 128 128, 1, Nothing) :
    ("tiles/black-green/vent-large", Position 1 1, Size 128 128, 1, Nothing) :
    ("tiles/black-green/vent-background-large", Position 1 1, Size 128 128, 1, Nothing) :
    ("tiles/black-green/panel-arrows-up", Position 1 1, Size 128 64, 1, Nothing) :
    ("tiles/black-green/panel-arrows-down", Position 1 1, Size 128 64, 1, Nothing) :
    ("tiles/black-green/pilotlamp-standard-left", Position 9 1, Size 64 64, 0.3, Just [0, 0, 0, 1, 1]) :
    ("tiles/black-green/pilotlamp-standard-right", Position 1 1, Size 64 64, 0.3, Just [0, 0, 0, 1, 1]) :
    ("tiles/black-green/pilotlamp-small-left", Position 9 1, Size 32 32, 0.25, Just [0, 0, 0, 1, 1]) :
    ("tiles/black-green/pilotlamp-small-right", Position 1 1, Size 32 32, 0.25, Just [0, 0, 0, 1, 1]) :
    ("tiles/black-green/aircon-left", Position 1 1, Size 64 128, 1, Nothing) :
    ("tiles/black-green/aircon-right", Position 1 1, Size 64 128, 1, Nothing) :
    ("tiles/black-green/tank-horizontal", Position 1 1, Size 160 64, 1, Nothing) :
    ("tiles/black-green/wallpaper-standard", Position 1 1, Size 64 64, 1, Nothing) :
    ("tiles/black-green/wallpaper-small", Position 1 1, Size 32 32, 1, Nothing) :
    ("tiles/black-green/wallpaper-large-vent", Position 1 1, Size 128 128, 1, Nothing) :
    ("tiles/black-green/terminal-standard-indoor", Position 5 5, Size 192 192, 1, Nothing) :
    ("tiles/black-green/terminal-standard-outdoor", Position 1 1, Size 192 192, 1, Nothing) :
    ("tiles/black-green/terminal-data-indoor", Position 5 5, Size 128 192, 1, Nothing) :
    ("tiles/black-green/terminal-data-outdoor", Position 1 1, Size 128 192, 1, Nothing) :
    ("tiles/black-green/terminal-battery-outdoor", Position 1 1, Size 288 192, 1, Nothing) :
    ("tiles/black-green/shadow-standard", Position 1 1, Size 32 64, 1, Nothing) :
    ("tiles/black-brown/panel-standard", Position 1 1, Size 64 64, 1, Nothing) :
    ("tiles/black-brown/panel-small", Position 1 1, Size 32 32, 1, Nothing) :
    ("tiles/black-brown/position-lamp-lower-left", Position 17 1, Size 64 64, 0.3, Just [0, 0, 0, 1, 1]) :
    ("tiles/black-brown/position-lamp-upper-left", Position 17 1, Size 64 64, 0.3, Just [0, 0, 0, 1, 1]) :
    ("tiles/black-brown/position-lamp-lower-right", Position 1 1, Size 64 64, 0.3, Just [0, 0, 0, 1, 1]) :
    ("tiles/black-brown/position-lamp-upper-right", Position 1 1, Size 64 64, 0.3, Just [0, 0, 0, 1, 1]) :
    ("tiles/black-brown/panel-chamfer-lower-left", Position 1 1, Size 64 64, 1, Nothing) :
    ("tiles/black-brown/panel-chamfer-lower-right", Position 1 1, Size 64 64, 1, Nothing) :
    ("tiles/black-brown/panel-chamfer-upper-left", Position 1 1, Size 64 64, 1, Nothing) :
    ("tiles/black-brown/panel-chamfer-upper-right", Position 1 1, Size 64 64, 1, Nothing) :
    ("tiles/black-brown/panel-number-01", Position 1 1, Size 320 256, 1, Nothing) :
    ("tiles/black-brown/panel-number-02", Position 1 1, Size 320 256, 1, Nothing) :
    ("tiles/black-brown/panel-number-03", Position 1 1, Size 320 256, 1, Nothing) :
    ("tiles/black-brown/panel-number-04", Position 1 1, Size 320 256, 1, Nothing) :
    ("tiles/black-brown/panel-number-05", Position 1 1, Size 320 256, 1, Nothing) :
    ("tiles/black-brown/panel-number-06", Position 1 1, Size 320 256, 1, Nothing) :
    ("tiles/black-brown/panel-number-07", Position 1 1, Size 320 256, 1, Nothing) :
    ("tiles/black-brown/panel-number-08", Position 1 1, Size 320 256, 1, Nothing) :
    ("tiles/black-brown/panel-number-09", Position 1 1, Size 320 256, 1, Nothing) :
    ("tiles/black-brown/panel-number-10", Position 1 1, Size 320 256, 1, Nothing) :
    ("tiles/black-brown/panel-arrows-up", Position 1 1, Size 128 64, 1, Nothing) :
    ("tiles/black-brown/panel-arrows-down", Position 1 1, Size 128 64, 1, Nothing) :
    ("tiles/black-brown/panel-arrows-left", Position 1 1, Size 64 128, 1, Nothing) :
    ("tiles/black-brown/panel-arrows-right", Position 1 1, Size 64 128, 1, Nothing) :
    ("tiles/black-brown/vent-large", Position 1 1, Size 128 128, 1, Nothing) :
    ("tiles/black-brown/vent-background-large", Position 1 1, Size 128 128, 1, Nothing) :
    ("tiles/black-brown/wallpaper-standard", Position 1 1, Size 64 64, 1, Nothing) :
    ("tiles/black-brown/wallpaper-large", Position 1 1, Size 128 128, 1, Nothing) :
    ("tiles/black-brown/wallpaper-horizontal", Position 1 1, Size 128 64, 1, Nothing) :
    ("tiles/black-brown/wallpaper-vertical", Position 1 1, Size 64 128, 1, Nothing) :
    ("tiles/black-brown/wallpaper-large-vent", Position 1 1, Size 128 128, 1, Nothing) :
    ("tiles/black-brown/wallpaper-number-01", Position 1 1, Size 328 264, 1, Nothing) :
    ("tiles/black-brown/wallpaper-number-02", Position 1 1, Size 328 264, 1, Nothing) :
    ("tiles/black-brown/wallpaper-number-03", Position 1 1, Size 328 264, 1, Nothing) :
    ("tiles/black-brown/wallpaper-number-04", Position 1 1, Size 328 264, 1, Nothing) :
    ("tiles/black-brown/wallpaper-number-05", Position 1 1, Size 328 264, 1, Nothing) :
    ("tiles/black-brown/wallpaper-number-06", Position 1 1, Size 328 264, 1, Nothing) :
    ("tiles/black-brown/wallpaper-number-07", Position 1 1, Size 328 264, 1, Nothing) :
    ("tiles/black-brown/wallpaper-number-08", Position 1 1, Size 328 264, 1, Nothing) :
    ("tiles/black-brown/wallpaper-number-09", Position 1 1, Size 328 264, 1, Nothing) :
    ("tiles/black-brown/wallpaper-number-10", Position 1 1, Size 328 264, 1, Nothing) :
    ("tiles/black-brown/terminal-standard-indoor", Position 1 1, Size 200 196, 1, Nothing) :
    ("tiles/black-brown/terminal-standard-outdoor", Position 1 1, Size 192 192, 1, Nothing) :
    ("tiles/black-brown/terminal-data-indoor", Position 1 1, Size 136 196, 1, Nothing) :
    ("tiles/black-brown/terminal-data-outdoor", Position 1 1, Size 128 192, 1, Nothing) :
    ("tiles/black-brown/shadow-standard", Position 1 1, Size 32 64, 1, Nothing) :
    ("tiles/black-brown/chain-standard", Position 1 1, Size 28 32, 1, Nothing) :
    ("tiles/black-brown/chain-connector-bottom", Position 1 1, Size 28 32, 1, Nothing) :
    ("tiles/black-brown/chain-connector-top", Position 1 1, Size 28 32, 1, Nothing) :
    ("tiles/black-brown/chain-fadeout", Position 1 1, Size 28 384, 1, Nothing) :
    ("tiles/stones-day/stone-standard-medium", Position 1 1, Size 64 64, 1, Nothing) :
    ("tiles/stones-day/stone-standard-light", Position 1 1, Size 64 64, 1, Nothing) :
    ("tiles/stones-day/stone-standard-dark", Position 1 1, Size 64 64, 1, Nothing) :
    ("tiles/stones-day/stone-small-medium", Position 1 1, Size 32 32, 1, Nothing) :
    ("tiles/stones-day/stone-small-light", Position 1 1, Size 32 32, 1, Nothing) :
    ("tiles/stones-day/stone-small-dark", Position 1 1, Size 32 32, 1, Nothing) :
    ("tiles/stones-day/wallpaper-standard", Position 1 1, Size 64 64, 1, Nothing) :
    ("tiles/stones-day/wallpaper-small", Position 1 1, Size 32 32, 1, Nothing) :
    ("tiles/stones-day/wallpaper-horizontal", Position 1 1, Size 128 64, 1, Nothing) :
    ("tiles/stones-day/wallpaper-vertical", Position 1 1, Size 64 128, 1, Nothing) :
    ("tiles/stones-day/terminal-standard-outdoor", Position 1 1, Size 192 192, 1, Nothing) :
    ("tiles/stones-day/terminal-standard-indoor", Position 1 1, Size 200 196, 1, Nothing) :
    ("tiles/stones-day/terminal-data-outdoor", Position 1 1, Size 128 192, 1, Nothing) :
    ("tiles/stones-day/terminal-data-indoor", Position 1 1, Size 136 196, 1, Nothing) :
    ("tiles/stones-day/shadow-standard", Position 1 1, Size 32 64, 1, Nothing) :
    ("tiles/stones-day/grass", Position 1 1, Size 64 32, 1, Nothing) :
    ("tiles/stones-day/daisies", Position 1 1, Size 64 32, 1, Nothing) :
    ("tiles/stones-day/coil-downwards-standard", Position 1 1, Size 40 64, 1, Nothing) :
    ("tiles/stones-day/pilotlamp", Position 1 1, Size 32 32, 1, Nothing) :
    ("tiles/stones-day/engine-01", Position 1 1, Size 128 64, 1, Nothing) :
    ("tiles/stones-day/engine-02", Position 1 1, Size 128 64, 1, Nothing) :
    ("tiles/stones-day/engine-03", Position 1 1, Size 128 64, 1, Nothing) :
    ("tiles/stones-day/engine-04", Position 1 1, Size 128 64, 1, Nothing) :
    ("tiles/stones-day/engine-05", Position 1 1, Size 128 64, 1, Nothing) :
    ("tiles/stones-day/engine-06", Position 1 1, Size 128 64, 1, Nothing) :
    ("tiles/stones-day/engine-07", Position 1 1, Size 128 64, 1, Nothing) :
    ("tiles/stones-day/engine-08", Position 1 1, Size 128 64, 1, Nothing) :
    ("tiles/stones-day/engine-09", Position 1 1, Size 128 64, 1, Nothing) :
    ("tiles/stones-day/engine-10", Position 1 1, Size 128 64, 1, Nothing) :
    ("tiles/frame/black-standard", Position 1 1, Size 64 64, 1, Nothing) :
    ("tiles/frame/black-bottom-standard", Position 1 1, Size 64 68, 1, Nothing) :
    ("tiles/frame/black-extra", Position 1 1, Size 76 64, 1, Nothing) :
    ("tiles/frame/black-bottom-extra", Position 1 1, Size 76 68, 1, Nothing) :
    ("tiles/frame/black-support-left", Position 1 1, Size 64 64, 1, Nothing) :
    ("tiles/frame/black-support-right", Position 1 1, Size 64 64, 1, Nothing) :
    ("tiles/frame/black-dot", Position 1 1, Size 4 4, 1, Nothing) :
    ("tiles/special/switch-transient-active", Position 1 1, Size 120 80, 1, Nothing) :
    ("tiles/neon/single-heart", Position 1 1, Size 588 520, 0.35, Just [0, 1, 2, 3, 4, 5, 6, 0, 6, 0, 6, 0, 6, 0]) :
    ("tiles/neon/controller", Position 1 1, Size 844 456, 0.35, Just [0, 1, 2, 3, 4, 5, 6]) :
    ("tiles/neon/pong", Position 1 1, Size 716 520, 0.25, Just [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]) :
    ("tiles/neon/rocket", Position 1 1, Size 972 584, 0.25, Just [0, 1, 2]) :
    ("tiles/neon/pac", Position 1 1, Size 716 468, 0.3, Just [0, 1, 2, 3]) :
    ("tiles/neon/tetris-01", Position 1 1, Size 332 340, 0.4, Just [0, 1, 2, 3, 4, 5]) :
    ("tiles/neon/snake", Position 1 1, Size 844 584, 0.25, Just [0, 1, 2, 0, 1, 2, 3, 4, 5]) :
    ("tiles/neon/skull", Position 1 1, Size 588 584, 0.35, Just [0, 1, 2, 3, 4, 5, 6, 7, 0, 7, 0, 7, 0, 7, 0]) :
    ("tiles/neon/beam-standard", Position 13 13, Size 52 52, 0.25, Just [0, 1]) :

    []

backgrounds :: [String]
backgrounds =
    "green-night" :
    "warm-dusk" :
    "submarine-blue" :
    "submarine-green" :
    "blue-sky" :
    []
