Easing
======

    {PI, sin, cos, pow} = Math

    τ = 2 * PI

    Easing =
      sinusoidal: (t) -> 
        1 - cos(t * τ / 4)

      sinusoidalOut: (t) ->
        0 + sin(t * τ / 4)

    polynomialEasings = ["linear", "quadratic", "cubic", "quartic", "quintic"]

    polynomialEasings.each (easing, i) ->
      exponent = i + 1
      sign = if exponent % 2 then 1 else -1

      Easing[easing] = (t) -> 
        pow(t, exponent)

      Easing["#{easing}Out"] = (t) -> 
        1 + sign * pow(t - 1, exponent)

    ["sinusoidal"].concat(polynomialEasings).each (easing) ->
      easeIn = Easing[easing]
      easeOut = Easing["#{easing}Out"]

      Easing["#{easing}InOut"] = (t) ->
        if t < 0.5
          easeIn(2 * t)
        else
          easeOut(2 * t - 1)

    module.exports = Easing
