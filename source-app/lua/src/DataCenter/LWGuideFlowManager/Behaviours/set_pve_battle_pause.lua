local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"bool", "paused"}
}
behaviour.optionalParams = {
  {
    "bool",
    "revertWhenClear",
    true
  }
}

function behaviour:Begin()
  self.origPaused = DataCenter.LWBattleManager.gamePause
  DataCenter.LWBattleManager:SetGamePause(self.paused)
  self.done = true
end

function behaviour:Clear()
  if self.revertWhenClear and self.origPaused ~= nil then
    DataCenter.LWBattleManager:SetGamePause(self.origPaused)
  end
end

return behaviour
