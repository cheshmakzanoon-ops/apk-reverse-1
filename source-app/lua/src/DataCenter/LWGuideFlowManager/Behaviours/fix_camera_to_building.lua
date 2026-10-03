local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"number", "buildingId"},
  {"number", "duration"}
}
behaviour.optionalParams = {
  {
    "number",
    "zoom",
    240
  }
}

function behaviour:Begin()
  self.__timer = 0
  local datas = DataCenter.BuildManager:GetBuildingDatasByBuildingId(self.buildingId)
  local data = datas[1]
  if data == nil then
    self:LogError("building data not found: " .. self.buildingId)
    return
  end
  local tile = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.Building), self.buildingId, "tiles") * 0.5 * TileSize
  local pos = SceneUtils.TileIndexToWorld(data.pointId, ForceChangeScene.City) - Vector3(tile, 0, tile)
  local offset = self.zoom * 0.707
  pos.x = pos.x + offset
  pos.z = pos.z - offset
  pos.y = self.zoom
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, self.duration + 1)
  if not IsNull(CS.SceneManager.World) then
    CS.SceneManager.World:LockCamera(pos, self.duration)
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
