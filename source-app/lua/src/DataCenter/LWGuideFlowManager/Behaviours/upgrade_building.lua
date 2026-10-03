local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"number", "buildingId"},
  {"number", "pointId"}
}
behaviour.optionalParams = {
  {
    "number",
    "targetLevel",
    nil
  }
}

function behaviour:__Awake()
  function self.OnBuildingUpgradeFinish(uuid)
    if self.buildingUUID == uuid then
      self.done = true
    end
  end
  
  function self.OnBuildingUpgradeFailed()
    self.canceled = true
  end
end

local BLOCKER_EXPIRE_TIME = 8

function behaviour:Begin()
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, BLOCKER_EXPIRE_TIME)
  local buildingData = DataCenter.BuildManager:GetBuildingDataByPointId(self.pointId)
  if buildingData == nil then
    self:LogError("buildingData at [" .. self.pointId .. "] not found!")
    return
  end
  if buildingData.itemId ~= self.buildingId then
    self:LogError("buildingData at [" .. self.pointId .. "] is not " .. self.buildingId .. "!")
    return
  end
  self.buildingUUID = buildingData.uuid
  EventManager:GetInstance():AddListener(EventId.BuildUpgradeFinish, self.OnBuildingUpgradeFinish)
  EventManager:GetInstance():AddListener(EventId.GF_upgrade_building_failed, self.OnBuildingUpgradeFailed)
  if self.targetLevel and buildingData.level >= self.targetLevel then
    self.done = true
    return
  end
  local param = {}
  param.uuid = tostring(self.buildingUUID)
  param.gold = BuildUpgradeUseGoldType.Yes
  param.upLevel = buildingData.level + 1
  param.clientParam = ""
  param.truckId = 0
  param.pathTime = 0
  param.robotUuid = 0
  SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew, param)
end

function behaviour:End()
  EventManager:GetInstance():RemoveListener(EventId.BuildUpgradeFinish, self.OnBuildingUpgradeFinish)
  EventManager:GetInstance():RemoveListener(EventId.GF_upgrade_building_failed, self.OnBuildingUpgradeFailed)
  UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  self.__blockerHandleID = nil
end

return behaviour
