----------------------------------------------------------------------------------------------------
-- bnse extensions.lua
-- This file takes priority over the default extensions.lua, and allows us to load custom modules
-- before the initSystems event happens.
-- This will soon be replaced by an official implementation.
----------------------------------------------------------------------------------------------------

-- Get the original extensions module
local originalExtensions = require('lua/common/extensions')

-- Load bnse modules
originalExtensions.addModulePath("lua/vehicle/extensions/auto/")
originalExtensions.loadModules("lua/vehicle/extensions/auto/")

-- Return the original extensions module
return originalExtensions