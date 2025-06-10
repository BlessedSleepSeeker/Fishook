# Procedural Generation of 3D Platformer Levels

- [Procedural Generation of 3D Platformer Levels](#procedural-generation-of-3d-platformer-levels)
  - [Context](#context)
  - [Idea](#idea)
  - [Algorithm Constraints](#algorithm-constraints)
  - [2-pass algorithm](#2-pass-algorithm)

## Context

Fishook is a 3D Platformer where you use a fishing hook to traverse levels and collect fishing baits. This require levels to be made. I suck at level design and doesn't like doing it, so I'm making a generation algorithm to do it for me.

Current objective is to be able to generate level in a finished world. Future objective is to be able to generate part of the level infinitely in any directions (chunk loading)

## Idea

The algorithm is going to be chunk-based with preset "tiles", which will be arranged by an algorithm based on various constraints.

Each tiles hold some space, and can or cannot be next to or close to other specific tiles. Each tile represent a mini platforming challenge.

The algorithm parameters are modified depending on biomes, which are defined from noise textures values. Some tiles can only appear in certains biomes or can't appear in others.

## Algorithm Constraints

Main Algorithm class
AlgorithmTiles class for the available tiles.
AlgorithmConstraints class for constraints values.
AlgorithmRules for things like finding the next tiles.

- Main seed
- Horizontal X Grid Size
  - Define the maximum amount of tiles in the X axis (north/south)
- Horitonzal Z Grid Size
  - Define the maximum amount of tiles in the Z axis (west/east)
- Vertical Y Grid Size
  - Define the maximum amount of tiles in the Y axis (up/down)
- Maximum amount of tiles
- Algorithm Type [Expand, WFC, Fill, ContinuedRandom] ->
  - Expand is "infinite" growth in every direction, next generated tile is simply the next one in the chosen grid coordinate system.
  - WFC for WaveFunctionCollapse. Find the lowest entropy tile, collapse it, reduce entropy on other tiles, repeat. Has additionals parameters to control wave propagation when collapsing options.
  - Fill between various preset tiles, connecting them.
  - ContinuedRandom create a continuous path : Generate a tile, select an empty neighbor, generate again...

## 2-pass algorithm

The first stage of the algorithm is pure level generation. The second stage is scene instancing and eye-candy, where we will transform some tiles according to a few rules.
