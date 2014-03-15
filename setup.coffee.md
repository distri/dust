Setup
=====

    require "jquery-utils"

    # Updating Application Cache and prompting for new version
    require "appcache"

    require "cornerstone"

    # HACK: HamlJr currntly requires a global `Observable`
    global.Observable = require "observable"
