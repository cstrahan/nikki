{-# language ScopedTypeVariables #-}

module Sorts.Robots.PathRobots.Configuration where


import Physics.Chipmunk

import Base

import Sorts.Nikki as Nikki (nikkiMass)


-- * platforms

-- | The mass of platforms.
-- (gravity has no effect on platforms
platformMass :: CpFloat = nikkiMass * 3.5 -- 3

platformFriction :: CpFloat = 0.75 -- 0.95

-- | general velocity of platforms
platformStandardVelocity :: CpFloat = 170 -- 150


-- * patrol robots

-- | time for the switch between red and blue lights when switched on
patrolFrameTime :: Seconds = 0.35

-- | The mass of platforms.
-- (gravity has no effect on platforms
patrolMass :: CpFloat = platformMass

patrolFriction :: CpFloat = platformFriction

-- | general velocity of platforms
patrolStandardVelocity :: CpFloat = platformStandardVelocity


-- * spring configuration (for all path robots)

data SpringConfiguration = SpringConfiguration {
    -- When the platform is further than this value away from its aim,
    -- the applied acceleration will have reached platformAcceleration
    springAcceleration :: CpFloat,
    -- factor of friction
    -- (not dependent on the velocity, like sliding friction)
    frictionFactor :: CpFloat,
    -- factor of drag
    -- (dependent on velocity, like air drag)
    dragFactor :: CpFloat
  }

-- | spring configuration for platforms that move on a path
pathSpringConfiguration = SpringConfiguration {
    springAcceleration = 2550, -- 4249.984,
    frictionFactor = 85,
    dragFactor = 1190
  }

-- | When the platforms are switched off or if there is just one path node.
singleNodeSpringConfiguration = SpringConfiguration {
    springAcceleration = 3500, -- 4249.984,
    frictionFactor = 85,
    dragFactor = 170
  }
