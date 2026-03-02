# Asteroids — Godot 4

A classic Asteroids arcade game built with the Godot 4 engine and GDScript.

## Gameplay

- Pilot a spaceship through an asteroid field
- Destroy asteroids to earn points
- Survive as long as possible

## Controls

| Key | Action |
|-----|--------|
| W | Thrust forward |
| S | Thrust backward |
| A | Rotate left |
| D | Rotate right |
| Space | Shoot |
| R | Restart (after game over) |

## Features

- Classic wireframe vector graphics style
- Asteroids spawn from screen edges in 3 sizes (small, medium, large)
- Asteroid splitting on destruction (large → 2 medium, medium → 2 small)
- Score tracking with HUD
- Increasing difficulty over time (spawn rate accelerates)
- Game over and restart system
- Screen wrapping for the player ship

## Technical Details

- **Engine**: Godot 4.3
- **Language**: GDScript
- **Rendering**: Custom `_draw()` calls for wireframe vector look
- **Collision**: Area2D with collision layers (Player=1, Asteroids=2, Shots=4)
- **Architecture**: Scene composition with signal-based communication

## Running

1. Open the project in Godot 4.3+
2. Press F5 or click the Play button
