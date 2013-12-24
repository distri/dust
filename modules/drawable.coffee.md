Drawable
========

The `Drawable` module is used to provide a simple draw method to the including
object.

Binds a default draw listener to draw a rectangle or a sprite, if one exists.

Binds an udtade listener to update the transform of the object.

Autoloads the sprite specified in I.sprite, if any.

>     player = Drawable
>       x: 15
>       y: 30
>       width: 5
>       height: 5
>       sprite: "my_cool_sprite"
>
>     player.draw(canvas)

Events
------

The drawing events triggered are:

>     beforeTransform
>     beforeDraw
>     draw
>     afterDraw
>     afterTransform

TODO: Find out how much each of these is actually used and cut any that aren't
useful.

`beforeTransform` is triggered before the object should be drawn. A canvas is passed as
the first argument. This does not apply the object's current transform.

`beforeDraw` is triggered before draw, but after the transform has been applied.

`draw` is triggered every time the object should be drawn. A canvas is passed as
the first argument.

>     player = GameObject
>       x: 0
>       y: 10
>       width: 5
>       height: 5
>
>     player.on "draw", (canvas) ->
>       # Text will be drawn positioned relatively to the object.
>       canvas.drawText
>         text: "Hey, drawing stuff is pretty easy."
>         color: "white"
>         x: 5
>         y: 5

`afterDraw` is triggered after draw with the transform still applied.

`afterTransform` is triggered after the object should be drawn. A canvas is passed as
the first argument. This transform is not applied.

    Bindable = require "./bindable"
    {defaults} = require "../util"

    module.exports = (I={}, self=Bindable(I)) ->
      defaults I,
        alpha: 1
        color: "#196"
        scale: 1
        scaleX: 1
        scaleY: 1
        zIndex: 0

      self.off ".Drawable"

      self.on 'draw.Drawable', (canvas) ->
        if I.alpha? and I.alpha != 1
          previousAlpha = canvas.context().globalAlpha
          canvas.context().globalAlpha = I.alpha

        if sprite = self.sprite()
          sprite.draw(canvas, -sprite.width / 2, -sprite.height / 2)
        else
          if I.radius?
            canvas.drawCircle
              x: 0
              y: 0
              radius: I.radius
              color: I.color
          else
            canvas.drawRect
              x: -I.width/2
              y: -I.height/2
              width: I.width
              height: I.height
              color: I.color
    
        if I.alpha? and I.alpha != 1
          canvas.context().globalAlpha = previousAlpha
      
      self.extend

Draw does not actually do any drawing itself, instead it triggers all of the draw events.
Listeners on the events do the actual drawing.

        draw: (canvas) ->
          self.trigger 'beforeTransform', canvas
      
          canvas.withTransform self.transform(), (canvas) ->
            self.trigger 'beforeDraw', canvas
            self.trigger 'draw', canvas
            self.trigger 'afterDraw', canvas
      
          self.trigger 'afterTransform', canvas
      
          return self
      
        sprite: ->
          if name = (I.sprite or I.spriteName)
            # TODO: Resource loader?
            Sprite.loadByName(name)

Returns the current transform, with translation, rotation, and flipping applied.

        transform: ->
          center = self.center()
      
          transform = Matrix.translation(center.x.floor(), center.y.floor())
      
          transform = transform.concat(Matrix.scale(I.scale * I.scaleX, I.scale * I.scaleY))
          transform = transform.concat(Matrix.rotation(I.rotation)) if I.rotation
      
          if I.spriteOffset
            transform = transform.concat(Matrix.translation(I.spriteOffset.x, I.spriteOffset.y))
      
          return transform
