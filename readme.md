# Bouncing Balls in Matlab

This Matlab functions creates colourful bouncing balls.  
`bouncingBall(speed, radius, balls, random_angles[0 or 1], angles[vector], precision)`

## Available Variables
All of the input variables have default values. The input `speed` sets the initial speed at which the balls move (default: `7`). `radius` controls their size (default: `10`). `balls` is the number of balls (default: `10`). Setting `random_angles` to `1` generates random directional for each ball (set to `0` by default). `angles` is the vector, from which the angles for all balls are drawn. Can only be used when `random_angles` is set to `0` (`[45 135 225 315]`). `precision` sets the size of margin in pixels, in which the collision detection should stop (default: `10`).

## Control Keys
During the animation, the behaviour of the balls can be controlled with key presses in the following ways.

- Press <kbd>↑</kbd> or <kbd>↓</kbd> to increase or decrease the **speed** of the balls. 
- Press <kbd>+</kbd> or <kbd>-</kbd> to increase or decrease the **size** of the balls. 
- Press <kbd>ESC</kbd> to end the simulation. 

## Requirements
This script uses [Psychtoolbox](http://psychtoolbox.org/) for the speedy drawing of the figures. Check on their websites for additional [system requirements](http://psychtoolbox.org/requirements.html).

Animating a large number number of balls at the same time may cause lags or stuttering depending on the available hardware.
