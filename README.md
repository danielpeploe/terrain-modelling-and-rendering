# Terrain Modelling and Rendering - COSC422 Advanced Computer Graphics

This project demonstrates terrain rendering using OpenGL and GLSL shaders. It includes loading height maps and textures, tessellation, and applying various visual effects such as fog and lighting.

## Dependencies

- OpenGL
- GLEW
- GLUT
- GLM

## How to run
`g++ Terrain.cpp -o terrain -lGL -lGLEW -lglut -lGLU && ./terrain `

## Controls
- Arrow Keys: Move the camera.
- Space: Toggle wireframe mode.
- l: Toggle level of detail.
- f: Toggle fog.
- w: Increase water level.
- e: Decrease water level.
- s: Decrease snow level.
- d: Increase snow level.
- c: Toggle cracking.
