local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"number", "duration"}
}
behaviour.optionalParams = {
  {
    "bool",
    "showArrow",
    false
  },
  {
    "number",
    "zoom",
    240
  }
}

function behaviour:__Awake()
  self.position = Vector3(self.positionX, self.positionY, self.positionZ)
end

function behaviour:Begin()
  local obstacle = DataCenter.MonopolyManager:GetCurObstacle()
  if not obstacle then
    self.done = true
    return
  end
  local data = obstacle.data
  if not data then
    self.done = true
    return
  end
  local pos = data:GetCenterWorldPos()
  if self.showArrow then
    self.arrowPosition = Vector3.New(pos.x, pos.y, pos.z)
  end
  local offset = self.zoom * 0.707
  pos.x = pos.x + offset
  pos.z = pos.z - offset
  pos.y = self.zoom
  self.__timer = 0
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, self.duration + 1)
  if not IsNull(CS.SceneManager.World) then
    CS.SceneManager.World:LockCamera(pos, self.duration)
  end
end

function behaviour:Update(dt)
  self.__timer = self.__timer + dt
  if self.__timer >= self.duration then
    self.done = true
    if self.showArrow then
      local param = {}
      param.position = CS.CSUtils.WorldPositionToUISpacePosition(self.arrowPosition)
      param.arrowType = ArrowType.Building
      param.positionType = PositionType.Screen
      DataCenter.ArrowManager:ShowArrow(param)
    end
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
