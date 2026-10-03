local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"number", "x"},
  {"number", "y"},
  {"number", "z"},
  {"number", "zoom"}
}
behaviour.optionalParams = {
  {
    "number",
    "duration",
    LookAtFocusTime
  }
}

function behaviour:__Awake()
  self.position = Vector3(self.x, self.y, self.z)
end

function behaviour:Begin()
  self.__timer = 0
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, self.duration + 1)
  if BattleFieldUtil.InBattleField() then
    GoToUtil.GotoDragonPos(self.position, self.zoom, self.duration, nil, LuaEntry.Player:GetCrossServerId(), LuaEntry.Player:GetCurWorldId())
  end
end

function behaviour:Update(dt)
  self.__timer = self.__timer + dt
  if self.__timer >= self.duration then
    self.done = true
  end
end

function behaviour:End()
  UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  self.__blockerHandleID = nil
end

function behaviour:Clear()
end

return behaviour
