Timed Events
============

The TimedEvents module allows arbitrary code to be executed at set intervals. 

`GameObject` includes this module by default.

    {defaults} = require "../util"

    module.exports = (I={}, self) ->
      defaults I,
        everyEvents: []
        delayEvents: []
    
      self.bind "update", (elapsedTime) ->
        for event in I.everyEvents
          {fn, period} = event

          continue if period <= 0

          while event.lastFired < I.age + elapsedTime
            self.sendOrApply(fn)
            event.lastFired += period
    
        [I.delayEvents, firingEvents] = I.delayEvents.partition (event) ->
          (event.delay -= elapsedTime) >= 0
    
        firingEvents.each (event) ->
          self.sendOrApply(event.fn)

      self.extend

Execute `fn` every `n` seconds.

>     player.every 4, ->
>       doSomething()

Execute a method by name periodically.

>     monster.every 3, "growl"

        every: (period, fn) ->
          return unless period > 0
  
          I.everyEvents.push
            fn: fn
            period: period
            lastFired: I.age
  
          return self
    
Execute a function or method after a number of seconds have passed.
    
>     self.delay 5, ->
>       engine.add
>         class: "Ghost"

        delay: (seconds, fn) ->
          I.delayEvents.push
            delay: seconds
            fn: fn
  
          return self
      
        # TODO: Move this into a more core module
        sendOrApply: (fn, args...) ->
          if typeof fn is "function"
            fn.apply(self, args)
          else
            self[fn](args...)
