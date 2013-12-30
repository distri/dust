Setup
=====

    require "jquery-utils"

    # Updating Application Cache and prompting for new version
    require "appcache"

    require "cornerstone"

    # TODO: Don't make these pure global
    global.Bindable = require "./modules/bindable"
    global.Sprite = require "sprite"
