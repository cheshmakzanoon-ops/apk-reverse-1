local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)

function behaviour:__Awake()
end

function behaviour:Begin()
  DataCenter.ExplorerTreasureManager:ShowGuide()
  self.done = true
end

function behaviour:Clear()
end

return behaviour
