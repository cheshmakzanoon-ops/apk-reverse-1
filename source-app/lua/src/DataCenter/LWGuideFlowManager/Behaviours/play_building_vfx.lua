local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"string", "resPath"},
  {"number", "buildingId"},
  {"number", "offsetX"},
  {"number", "offsetY"},
  {"number", "offsetZ"},
  {"number", "eulerX"},
  {"number", "eulerY"},
  {"number", "eulerZ"},
  {"number", "scaleX"},
  {"number", "scaleY"},
  {"number", "scaleZ"},
  {"number", "duration"}
}
behaviour.optionalParams = {
  {
    "bool",
    "exitAtBegin",
    true
  },
  {
    "number",
    "blockerExpireTime",
    999
  }
}

function behaviour:__Awake()
  self.offset = Vector3(self.offsetX, self.offsetY, self.offsetZ)
  self.euler = Vector3(self.eulerX, self.eulerY, self.eulerZ)
  self.scale = Vector3(self.scaleX, self.scaleY, self.scaleZ)
  
  function self.OnVfxLoaded(handle)
    if handle.isError then
      self:LogError("load res failed:" .. self.resPath)
      self.done = true
      return
    end
    local datas = DataCenter.BuildManager:GetBuildingDatasByBuildingId(self.buildingId)
    local data = datas[1]
    if data == nil then
      self:LogError("building data not found: " .. self.buildingId)
      self.done = true
      return
    end
    local tile = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.Building), self.buildingId, "tiles") * 0.5 * TileSize
    local pos = SceneUtils.TileIndexToWorld(data.pointId, ForceChangeScene.City) - Vector3(tile, 0, tile)
    handle.gameObject.transform.position = pos + self.offset
    handle.gameObject.transform.eulerAngles = self.euler
    handle.gameObject.transform.localScale = self.scale
    if self.exitAtBegin and 0 < self.duration then
      TimerManager:GetInstance():DelayInvoke(function()
        if not IsNull(handle) then
          handle:Destroy()
        end
      end, self.duration)
      self.done = true
    else
      self.timer = self.duration
    end
  end
end

function behaviour:Begin()
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, self.blockerExpireTime)
  self.vfx = CS.GameEntry.Resource:InstantiateAsync(self.resPath)
  self.vfx:completed("+", self.OnVfxLoaded)
end

function behaviour:Update(dt)
  if self.timer ~= nil and self.timer > 0 then
    self.timer = self.timer - dt
    if self.timer <= 0 then
      self.vfx:Destroy()
      self.done = true
    end
  end
end

function behaviour:End()
  UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  self.__blockerHandleID = nil
  self.vfx = nil
end

return behaviour
