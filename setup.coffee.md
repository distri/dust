Setup
=====

    require "jquery-utils"

    # Updating Application Cache and prompting for new version
    require "appcache"

    require "cornerstone"

    # HACK: HamlJr currntly requires a global `Observable`
    # Maybe Cornerstone should provide Observable as a global,
    # but we probably want to let people include it on their own.
    global.Observable = require "observable"

    # TODO: Eventually remove this from globals, or have Cornerstone add it
    # if we want to keep it
    global.Bindable = require "./modules/bindable"
