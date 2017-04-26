Setup
=====

    require "jquery-utils"

    # Updating Application Cache and prompting for new version
    require "appcache"

    require "cornerstone"

    global.Observable = Model.Observable

    # TODO: Eventually remove this from globals, or have Cornerstone add it
    # if we want to keep it
    global.Bindable = require "./modules/bindable"
