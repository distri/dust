Main
====

    require "./setup"
    
    TouchCanvas = require "touch-canvas"
    
    module.exports =
      init: (require) ->
        {width, height} = require "/pixie"

        canvas = TouchCanvas
          width: width
          height: height
    
        $("body").append $ "<div>",
          class: "main center"
    
        $(".main").append canvas.element()
    
        canvas.fill("orange")
