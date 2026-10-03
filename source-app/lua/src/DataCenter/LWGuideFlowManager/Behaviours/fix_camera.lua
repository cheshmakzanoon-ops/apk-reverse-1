local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"number", "positionX"},
  {"number", "positionY"},
  {"number", "positionZ"},
  {"number", "duration"}
}

function behaviour:__Awake()
  self.position = Vector3(self.positionX, self.positionY, self.positionZ)
end

function behaviour:Begin()
  self.__timer = 0
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, self.duration + 1)
  if not IsNull(CS.SceneManager.World) then
    CS.SceneManager.World:LockCamera(self.position, self.duration)
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
  if not IsNull(CS.SceneManager.World) then
    CS.SceneManager.World:FreeCamera()
  end
end

return behaviour
