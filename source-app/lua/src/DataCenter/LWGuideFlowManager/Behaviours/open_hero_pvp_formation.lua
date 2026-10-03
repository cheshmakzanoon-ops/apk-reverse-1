local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"number", "openType"}
}

function behaviour:__Awake()
end

function behaviour:Begin()
  if self.openType == 1 then
    local formationList = DataCenter.ArmyFormationDataManager:GetArmyFormationIdList()
    local maxPowerArmyInfo
    for i, v in pairs(formationList) do
      local armyInfo = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(v)
      if armyInfo then
        local power = armyInfo:GetTotalCapacity()
        if maxPowerArmyInfo == nil or power > maxPowerArmyInfo:GetTotalCapacity() then
          maxPowerArmyInfo = armyInfo
        end
      end
    end
    if maxPowerArmyInfo then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.ParkingLotBuilding, maxPowerArmyInfo.buildingUuid)
      self.done = true
    else
      self:LogError("maxPowerArmyInfo not found, open_hero_pvp_formation guide failed")
    end
  end
end

function behaviour:Clear()
end

return behaviour
