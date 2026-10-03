local LastStandBuildingManager = BaseClass("LastStandBuildingManager", CEventable)
local buildingUnit = require("DataCenter.LWBattle.Logic.LastStand.LastStandBuilding.LastStandBuildingUnit")
local buildingTemplate = require("DataCenter.LWBattle.Logic.LastStand.LastStandBuilding.LastStandBuildingTemplate")

function LastStandBuildingManager:__init(logic)
  self.allBuilding = {}
  self.logic = logic
  self.buildingTemplateDict = nil
  self:TryInitBuildingTemplate()
  self:RegisterEvent(EventId.LastStandHomeBuildFinish, self.LastStandHomeBuildFinish)
end

function LastStandBuildingManager:Destroy()
  self:UnregisterEvent(EventId.LastStandHomeBuildFinish)
  for guid, building in pairs(self.allBuilding) do
    if building then
      building:OnDestroy()
    end
  end
end

function LastStandBuildingManager:TryInitBuildingTemplate()
  if self.buildingTemplateDict == nil then
    self.buildingTemplateDict = {}
    LocalController:instance():visitTable(TableName.lw_last_stand_building, function(id, lineData)
      if self.buildingTemplateDict[id] == nil and lineData ~= nil then
        local template = buildingTemplate.New()
        template:UpdateData(lineData)
        self.buildingTemplateDict[id] = template
      end
    end)
  end
end

local buildingHospital = require("DataCenter.LWBattle.Logic.LastStand.LastStandBuilding.LastStandHospital")
local buildingBarracks = require("DataCenter.LWBattle.Logic.LastStand.LastStandBuilding.LastStandBarracks")
local buildingArmyYard = require("DataCenter.LWBattle.Logic.LastStand.LastStandBuilding.LastStandArmyYard")
local buildingTurret = require("DataCenter.LWBattle.Logic.LastStand.LastStandBuilding.LastStandTurret")
local buildingHome = require("DataCenter.LWBattle.Logic.LastStand.LastStandBuilding.LastStandHome")
local LastStandGate = require("DataCenter.LWBattle.Logic.LastStand.LastStandBuilding.LastStandGate")

function LastStandBuildingManager:AddBuilding(guid)
  if not self.allBuilding[guid] then
    local logic = self.logic
    if not logic then
      return
    end
    local building = buildingUnit.New(logic)
    building:Init(logic)
    self.allBuilding[guid] = building
  end
  return self.allBuilding[guid]
end

function LastStandBuildingManager:RemoveBuilding(guid)
  if self.allBuilding[guid] then
    self.allBuilding[guid] = nil
  end
  self.logic:RemoveUnit(guid)
end

function LastStandBuildingManager:OnUpdate(deltaTime)
  for guid, building in pairs(self.allBuilding) do
    if building then
      building:OnUpdate(deltaTime)
    end
  end
end

function LastStandBuildingManager:AddSoliderToArmyYard(sourceBuildingUid)
  if not sourceBuildingUid then
    return
  end
  for guid, building in pairs(self.allBuilding) do
    if building and building.lastStandBuildingType == LastStandBuildType.ArmyYard and building:AddSoliderToArmyYard(sourceBuildingUid) then
      break
    end
  end
end

function LastStandBuildingManager:AddSoldierToHospital()
  for guid, building in pairs(self.allBuilding) do
    if building and building.lastStandBuildingType == LastStandBuildType.Hospital then
      building:AddSoliderToHospital()
      break
    end
  end
end

function LastStandBuildingManager:GetBuildingByType(buildingType)
  for guid, building in pairs(self.allBuilding) do
    if building and building.lastStandBuildingType == buildingType then
      return building
    end
  end
  return nil
end

function LastStandBuildingManager:GetBuildingById(buildingConfigId)
  for guid, building in pairs(self.allBuilding) do
    if building and building:GetConfigId() == buildingConfigId then
      return building
    end
  end
  return nil
end

function LastStandBuildingManager:IsBuildingDone(buildingConfigId)
  local building = self:GetBuildingById(buildingConfigId)
  if not building then
    return false
  end
  return building:IsBuildingDone()
end

function LastStandBuildingManager:ArmyYardIsNotFull()
  for guid, building in pairs(self.allBuilding) do
    if building and building.lastStandBuildingType == LastStandBuildType.ArmyYard and building:IsBuildingDone() then
      local isFull = building:IsSoliderReachMaxCount()
      if not isFull then
        return true
      end
    end
  end
  return false
end

function LastStandBuildingManager:GetNearestDoor(center)
  local minDis = IntMaxValue
  local door
  for guid, building in pairs(self.allBuilding) do
    if building and building.lastStandBuildingType == LastStandBuildType.Gate then
      local dis = Vector3.ManhattanDistanceXZ(center, building:GetPosition())
      if minDis > dis then
        minDis = dis
        door = building
      end
    end
  end
  return door
end

function LastStandBuildingManager:IsHomeBuildingDone()
  for guid, building in pairs(self.allBuilding) do
    if building and building.lastStandBuildingType == LastStandBuildType.Home then
      return building:IsBuildingDone()
    end
  end
  return false
end

function LastStandBuildingManager:LastStandHomeBuildFinish()
  for guid, building in pairs(self.allBuilding) do
    if building and building:CheckIsPreBuildingExistForBuilding() then
      building:ShowBuilding()
    end
  end
end

function LastStandBuildingManager:GetBuildingConfigById(id)
  if self.buildingTemplateDict and self.buildingTemplateDict[id] then
    return self.buildingTemplateDict[id]
  end
  return nil
end

function LastStandBuildingManager:InitBuilding(startBuildingList, allBuildingList)
  for _, v in pairs(startBuildingList) do
    local id = v.id
    local config = self:GetBuildingConfigById(id)
    local pos = v.pos
    if config then
      self:CreateBuildingById(id, pos)
    end
  end
  for _, v in pairs(allBuildingList) do
    local id = v.id
    local config = self:GetBuildingConfigById(id)
    local pos = v.pos
    if config then
      self:CreateBuildingById(id, pos)
    end
  end
  self:CreateGate()
end

function LastStandBuildingManager:IsPreBuildingExist(buildingId)
  for guid, building in pairs(self.allBuilding) do
    if building and building:GetConfigId() == buildingId and building:IsBuildingDone() then
      return true
    end
  end
  return false
end

function LastStandBuildingManager:CreateBuildingById(id, pos)
  local config = self:GetBuildingConfigById(id)
  local buildingType = config.type
  if buildingType == LastStandBuildType.Hospital then
    local hospital = ObjectPool:GetInstance():Load(buildingHospital)
    hospital:Init(self.logic, config, pos)
    self.logic:AddUnit(hospital)
    self.allBuilding[hospital.guid] = hospital
  elseif buildingType == LastStandBuildType.Barracks then
    local barracks = ObjectPool:GetInstance():Load(buildingBarracks)
    barracks:Init(self.logic, config, pos)
    self.logic:AddUnit(barracks)
    self.allBuilding[barracks.guid] = barracks
  elseif buildingType == LastStandBuildType.ArmyYard then
    local armyYard = ObjectPool:GetInstance():Load(buildingArmyYard)
    armyYard:Init(self.logic, config, pos)
    self.logic:AddUnit(armyYard)
    self.allBuilding[armyYard.guid] = armyYard
  elseif buildingType == LastStandBuildType.Turret then
    local turret = ObjectPool:GetInstance():Load(buildingTurret)
    turret:Init(self.logic, config, pos)
    self.logic:AddUnit(turret)
    self.allBuilding[turret.guid] = turret
  elseif buildingType == LastStandBuildType.Home then
    local home = ObjectPool:GetInstance():Load(buildingHome)
    home:Init(self.logic, config, pos)
    self.logic:AddUnit(home)
    self.allBuilding[home.guid] = home
  end
end

function LastStandBuildingManager:CreateGate()
  local gateInfo = self.logic:GetDoorInfo()
  for i = 1, #gateInfo do
    local gate = ObjectPool:GetInstance():Load(LastStandGate)
    local config = self:GetBuildingConfigById(gateInfo[i].configId or 6000)
    local pos = {
      x = gateInfo[i].posX,
      z = gateInfo[i].posZ
    }
    gate:Init(self.logic, config, pos, gateInfo[i])
    self.logic:AddUnit(gate)
    self.allBuilding[gate.guid] = gate
  end
end

function LastStandBuildingManager:GetAllBuilding()
  return self.allBuilding
end

function LastStandBuildingManager:GetBuildingConfig(type, id)
  for k, v in pairs(self.buildingTemplateDict) do
    if v.type == type and v.id == id then
      return v
    end
  end
  return nil
end

function LastStandBuildingManager:GetCurHomeLevel()
  for guid, building in pairs(self.allBuilding) do
    if building and building.lastStandBuildingType == LastStandBuildType.Home then
      return building:GetCurLevel()
    end
  end
  return 1
end

function LastStandBuildingManager:OpenDoor(doorType, direction)
  for guid, building in pairs(self.allBuilding) do
    if building and building.lastStandBuildingType == LastStandBuildType.Gate and building:IsBuildingDone() then
      local type = building:GetDoorType()
      if type == doorType then
        building:OpenDoor(direction)
      end
    end
  end
end

function LastStandBuildingManager:CloseDoor(doorType)
  for guid, building in pairs(self.allBuilding) do
    if building and building.lastStandBuildingType == LastStandBuildType.Gate and building:IsBuildingDone() and building:GetDoorType() == doorType then
      building:CloseDoor()
    end
  end
end

function LastStandBuildingManager:CheckNeedShowUpgradeUI(coinNum)
  if not coinNum or coinNum <= 0 then
    for guid, building in pairs(self.allBuilding) do
      if building then
        building:HideUpgradeUI()
      end
    end
    return
  end
  for guid, building in pairs(self.allBuilding) do
    if building:IsBuildingDone() then
      local isPrebuildingExist = building:CheckIsPreBuildingExistForUpgrade()
      if building and isPrebuildingExist and not building:IsMaxLevel() then
        building:ShowUpgradeUI()
      else
        building:HideUpgradeUI()
      end
    end
  end
end

function LastStandBuildingManager:CheckCanShowBuilding()
  for guid, building in pairs(self.allBuilding) do
    if building and not building.isShown then
      local isPrebuildingExist = building:CheckIsPreBuildingExistForBuilding()
      if isPrebuildingExist then
        building:ShowBuilding()
      end
    end
  end
end

function LastStandBuildingManager:GetNearestBuilding(pos)
  local minDis = IntMaxValue
  local building
  for guid, v in pairs(self.allBuilding) do
    if v and v.isShown then
      local dis = Vector3.ManhattanDistanceXZ(pos, v:GetPosition())
      if minDis > dis then
        minDis = dis
        building = v
      end
    end
  end
  return building
end

function LastStandBuildingManager:GetBuildingByUid(uid)
  for guid, v in pairs(self.allBuilding) do
    if v and v.guid == uid then
      return v
    end
  end
  return nil
end

return LastStandBuildingManager
