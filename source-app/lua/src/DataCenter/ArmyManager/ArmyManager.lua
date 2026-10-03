local ArmyManager = BaseClass("ArmyManager")
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

local function __init(self)
  self.allArmy = {}
end

local function __delete(self)
  self.allArmy = nil
end

local function InitData(self, message)
  if message.army ~= nil then
    self.allArmy = {}
    for k, v in pairs(message.army) do
      self:UpdateOneArmy(v)
    end
  end
end

local function UpdateOneArmy(self, message)
  if message ~= nil then
    local id = message.id
    local one = self:FindArmy(id)
    if one == nil then
      one = ArmyInfo.New()
      one:UpdateInfo(message)
      self.allArmy[id] = one
    else
      one:UpdateInfo(message)
    end
  end
end

local function FindArmy(self, id)
  return self.allArmy[id]
end

local function PushArmyChangeHandle(self, message)
  if message.army ~= nil then
    for k, v in pairs(message.army) do
      self:UpdateOneArmy(v)
    end
    EventManager:GetInstance():Broadcast(EventId.TrainArmyData)
  end
end

local function ArmyAddMessageHandle(self, message)
  if message.errorCode == nil then
    if message.resource ~= nil then
      LuaEntry.Resource:UpdateResource(message.resource)
    end
    if message.gold ~= nil then
      LuaEntry.Player.gold = message.gold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    if message.remainArray ~= nil then
      DataCenter.ItemData:UpdateItems(message.remainArray)
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshItems)
    end
    local itemId
    local queueType = NewQueueType.Default
    local queue = message.queue
    if queue ~= nil then
      local itemObj = queue.itemObj
      if itemObj ~= nil then
        local tempItemId = itemObj.itemId
        local subItemId = string.split(tempItemId, ";")
        if subItemId ~= nil and 1 < #subItemId then
          itemId = subItemId[1]
        end
        queueType = queue.type
        DataCenter.QueueDataManager:UpdateQueueData(queue)
        local buildId = DataCenter.BuildManager:GetBuildIdByNewQueue(queueType)
      end
    end
    if message.userArmy ~= nil then
      local armyId = message.userArmy.id
      local lastCount = 0
      local army = self:FindArmy(armyId)
      if army ~= nil then
        lastCount = army.free
      end
      self:UpdateOneArmy(message.userArmy)
      if army == nil then
        army = self:FindArmy(armyId)
      end
      if army ~= nil and lastCount < army.free then
        local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
        if template ~= nil then
          do
            local str = Localization:GetString("130058", Localization:GetString(template.name) .. " x" .. army.free - lastCount)
            local max = DataCenter.ArmyManager:GetArmyNumMax()
            local total = DataCenter.ArmyManager:GetTotalArmyNum()
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UINoticeEquipTips) then
              TimerManager:GetInstance():DelayInvoke(function()
                UIManager:GetInstance():OpenWindow(UIWindowNames.UISoliderGetTip, {anim = true}, str, army.free - lastCount, total, max, max, template.arm)
              end, 3)
            else
              UIManager:GetInstance():OpenWindow(UIWindowNames.UISoliderGetTip, {anim = true}, str, army.free - lastCount, total, max, max, template.arm)
            end
          end
        end
      end
      EventManager:GetInstance():Broadcast(EventId.TrainArmyData, armyId)
    end
    if itemId ~= nil then
      local buildId = DataCenter.BuildManager:GetBuildIdByNewQueue(queueType)
      local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
      if list ~= nil then
        for k, v in pairs(list) do
          local signal = SFSObject.New()
          signal:PutLong("bUuid", v.uuid)
          signal:PutInt("queueType", queueType)
          EventManager:GetInstance():Broadcast(EventId.TrainingArmy, signal)
        end
      end
    end
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  end
end

local function SoldierUpMessageHandle(self, message)
  if message.errorCode == nil then
    if message.resource ~= nil then
      LuaEntry.Resource:UpdateResource(message.resource)
    end
    if message.gold ~= nil then
      LuaEntry.Player.gold = message.gold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    if message.remainArray ~= nil then
      DataCenter.ItemData:UpdateItems(message.remainArray)
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshItems)
    end
    local queue = message.queue
    if queue ~= nil then
      local itemObj = queue.itemObj
      if itemObj ~= nil then
        local itemId = ""
        local tempItemId = itemObj.itemId
        local subItemId = string.split(tempItemId, ";")
        if subItemId ~= nil and 1 < #subItemId then
          itemId = subItemId[1]
        end
        DataCenter.QueueDataManager:UpdateQueueData(queue)
        local queueType = queue.type
        local buildId = DataCenter.BuildManager:GetBuildIdByNewQueue(queueType)
        local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
        if list ~= nil then
          for k, v in pairs(list) do
            local signal = SFSObject.New()
            signal:PutLong("bUuid", v.uuid)
            signal:PutInt("queueType", queueType)
            EventManager:GetInstance():Broadcast(EventId.TrainingArmy, signal)
          end
        end
      end
    end
    if message.srcArmy ~= nil then
      self:UpdateOneArmy(message.srcArmy)
    end
    if message.upgradeArmy ~= nil then
      local armyId = message.upgradeArmy.id
      local lastCount = 0
      local army = self:FindArmy(armyId)
      if army ~= nil then
        lastCount = army.free
      end
      self:UpdateOneArmy(message.upgradeArmy)
      if army == nil then
        army = self:FindArmy(armyId)
      end
      if army ~= nil and lastCount < army.free then
        local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
        if template ~= nil then
          UIUtil.ShowTips(Localization:GetString("360105", Localization:GetString(template.name) .. " x" .. army.free - lastCount))
        end
      end
      EventManager:GetInstance():Broadcast(EventId.TrainArmyData, armyId)
    end
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  end
end

local function GetArmyQueue(self, type)
  return DataCenter.QueueDataManager:GetQueueByType(type)
end

local function GetArmyQueueTypeByBuildId(self, buildId)
  if buildId == BuildingTypes.FUN_BUILD_CAR_BARRACK then
    return NewQueueType.CarSoldier
  elseif buildId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
    return NewQueueType.BowSoldier
  elseif buildId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
    return NewQueueType.FootSoldier
  end
  return NewQueueType.Default
end

local function SendSpeedFinishQueue(self, qUuid)
  SFSNetwork.SendMessage(MsgDefines.QueueCcdMNew, {
    qUUID = qUuid,
    itemIDs = "",
    isGold = IsGold.UseGold
  })
end

local function GetSoldierTypeByBuildId(self, buildId)
  if buildId == BuildingTypes.FUN_BUILD_CAR_BARRACK then
    return OldSoldierType.CarSoldier
  elseif buildId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
    return OldSoldierType.BowSoldier
  elseif buildId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
    return OldSoldierType.FootSoldier
  end
  return NewQueueType.Default
end

local function GetExtraData(self, soldierType)
  return nil
end

local function GetArmyFreeList(self)
  local list = {}
  table.walk(self.allArmy, function(k, v)
    list[k] = v.free
  end)
  return list
end

local function GetQueueArmyTemplate(self, type)
  local queue = self:GetArmyQueue(type)
  if queue ~= nil and queue.itemId ~= nil and queue.itemId ~= "" then
    local armyId = ""
    local tempList = string.split(queue.itemId, ";")
    if tempList ~= nil and 3 < #tempList then
      armyId = tempList[3]
    elseif tempList ~= nil and 1 < #tempList then
      armyId = tempList[1]
    end
    return DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
  end
end

local function GetQueueArmyNum(self, buildType)
  local queueType = DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(buildType)
  local count = 0
  local queue = self:GetArmyQueue(queueType)
  if queue ~= nil and queue.itemId ~= nil and queue.itemId ~= "" then
    local tempList = string.split(queue.itemId, ";")
    if tempList ~= nil and 3 < #tempList then
      count = toInt(tempList[4])
    elseif tempList ~= nil and 1 < #tempList then
      count = toInt(tempList[2])
    end
  end
  return count
end

local function CheckSendFinish(self, queueType)
  local queue = self:GetArmyQueue(queueType)
  if queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
    SFSNetwork.SendMessage(MsgDefines.QueueFinish, {
      uuid = queue.uuid
    })
    return true
  end
  return false
end

local function GetMaxUnLockId(self, buildId, checkArmyUnlock)
  local result = 0
  local armyId = ""
  local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  local unlockArmyId = self:GetArmyUnlock(buildId)
  if checkArmyUnlock ~= true then
    unlockArmyId = nil
  end
  if buildDesTemplate ~= nil then
    local open_arms = buildDesTemplate.open_arms
    if open_arms ~= nil and open_arms ~= "" then
      local spl = string.split(open_arms, ";")
      for k, v in ipairs(spl) do
        if self:IsUnLock(v) and unlockArmyId ~= v then
          result = k
          armyId = v
        end
      end
    end
  end
  return result, armyId
end

local function IsUnLock(self, id)
  local tempK, tempV = self:GetLockTrainBuild(id)
  if tempK ~= nil and tempV ~= nil then
    return false
  end
  tempK, tempV = self:GetLockTrainScience(id)
  if tempK ~= nil and tempV ~= nil then
    return false
  end
  return true
end

local function GetLockTrainBuild(self, id)
  local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(id)
  if template ~= nil then
    for k, v in ipairs(template.unlock_train_build) do
      if not DataCenter.BuildManager:HasBuildByIdAndLevel(v.buildId, v.level) then
        return v.buildId, v.level
      end
    end
  end
end

local function GetLockTrainScience(self, id)
  local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(id)
  if template ~= nil then
    for k, v in ipairs(template.unlock_train_science) do
      if not DataCenter.ScienceManager:HasScienceByIdAndLevel(v.scienceId, v.level) then
        return v.scienceId, v.level
      end
    end
  end
end

local function IsCanUpgrade(self, id, buildId)
  local armys = self:GetArmyList(buildId)
  local army = self:FindArmy(id)
  if army == nil or army.free <= 0 then
    return false
  end
  local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(id)
  for k, v in ipairs(armys) do
    local templateV = DataCenter.ArmyTemplateManager:GetArmyTemplate(v)
    if templateV and templateV.level > template.level then
      local flag = true
      for tk, tv in ipairs(templateV.unlock_upgrade_build) do
        if not DataCenter.BuildManager:HasBuildByIdAndLevel(tv.buildId, tv.level) then
          flag = false
        end
      end
      if flag then
        return true
      end
    end
  end
  return false
end

local function GetCanUnLockUpgrade(self, buildId)
  local effectNum = 0
  if buildId == BuildingTypes.FUN_BUILD_CAR_BARRACK then
    effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.TANK_UPGRADE_SWITCH)
  elseif buildId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
    effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.PLANE_UPGRADE_SWITCH)
  elseif buildId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
    effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.INFANTRY_UPGRADE_SWITCH)
  end
  if effectNum < 1 then
    return false
  else
    return true
  end
end

local function GetMaxUpgradeId(self, id, buildId)
  local result = -1
  local armys = self:GetArmyList(buildId)
  local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(id)
  for k, v in ipairs(armys) do
    local templateV = DataCenter.ArmyTemplateManager:GetArmyTemplate(v)
    if templateV.level > template.level then
      local flag = true
      for tk, tv in ipairs(templateV.unlock_upgrade_build) do
        if not DataCenter.BuildManager:HasBuildByIdAndLevel(tv.buildId, tv.level) then
          flag = false
        end
      end
      for tk, tv in ipairs(templateV.unlock_upgrade_science) do
        if not DataCenter.ScienceManager:HasScienceByIdAndLevel(tv.scienceId, tv.level) then
          flag = false
        end
      end
      if flag then
        result = v
      else
        break
      end
    end
  end
  return result
end

local function GetArmyList(self, buildId)
  local result = {}
  local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildDesTemplate ~= nil then
    local open_arms = buildDesTemplate.open_arms
    if open_arms ~= nil and open_arms ~= "" then
      local spl = string.split(open_arms, ";")
      for k, v in ipairs(spl) do
        table.insert(result, v)
      end
    end
  end
  return result
end

local function GetArmyNumMax(self)
  local max = math.floor(LuaEntry.Effect:GetGameEffect(EffectDefine.APS_ARMY_NUM_MAX))
  return math.max(max, 1)
end

local function GetTotalArmyNum(self)
  local freeSoldiers = self:GetArmyFreeList()
  local march = self:GetTotalMarchArmyNum()
  local injured = DataCenter.HospitalManager:GetHospitalCount()
  local soliderNum = injured
  table.walk(freeSoldiers, function(k, v)
    soliderNum = soliderNum + v
  end)
  table.walk(march, function(k, v)
    soliderNum = soliderNum + v
  end)
  local armyBuilds = BarracksBuild
  for _, v in pairs(armyBuilds) do
    soliderNum = soliderNum + self:GetQueueArmyNum(v)
  end
  return soliderNum
end

local function GetTotalMarchArmyNum(self)
  local list = {}
  table.walk(self.allArmy, function(k, v)
    list[k] = v.march
  end)
  return list
end

local function GetTotalMarchAndFreeArmyNum(self)
  local list = {}
  table.walk(self.allArmy, function(k, v)
    list[k] = v.march + v.free
  end)
  return list
end

local function GetArmyDataForPve(self)
  local list = {}
  table.walk(self.allArmy, function(k, v)
    list[k] = v.march + v.free
  end)
  local hospital = DataCenter.HospitalManager:GetAllHospital()
  if hospital ~= nil and 0 < #hospital then
    for k, v in pairs(hospital) do
      local soldierId = v.armyId
      if list[soldierId] ~= nil then
        list[soldierId] = list[soldierId] + v.heal + v.dead
      else
        list[soldierId] = v.heal + v.dead
      end
    end
  end
  return list
end

local function GetArmyUnlock(self, buildId)
  if buildId == nil then
    return ""
  end
  local userUid = LuaEntry.Player.uuid
  local key = userUid .. "_" .. tostring(buildId)
  local id = Setting:GetString(key, "")
  return id
end

local function SaveArmyUnlock(self, buildId, armyId)
  local userUid = LuaEntry.Player.uuid
  local key = userUid .. "_" .. tostring(buildId)
  Setting:SetString(key, armyId)
  EventManager:GetInstance():Broadcast(EventId.UnlockArmy, buildId)
end

ArmyManager.__init = __init
ArmyManager.__delete = __delete
ArmyManager.InitData = InitData
ArmyManager.UpdateOneArmy = UpdateOneArmy
ArmyManager.FindArmy = FindArmy
ArmyManager.PushArmyChangeHandle = PushArmyChangeHandle
ArmyManager.ArmyAddMessageHandle = ArmyAddMessageHandle
ArmyManager.SoldierUpMessageHandle = SoldierUpMessageHandle
ArmyManager.GetArmyQueue = GetArmyQueue
ArmyManager.GetArmyQueueTypeByBuildId = GetArmyQueueTypeByBuildId
ArmyManager.SendSpeedFinishQueue = SendSpeedFinishQueue
ArmyManager.GetSoldierTypeByBuildId = GetSoldierTypeByBuildId
ArmyManager.GetExtraData = GetExtraData
ArmyManager.GetArmyFreeList = GetArmyFreeList
ArmyManager.GetQueueArmyTemplate = GetQueueArmyTemplate
ArmyManager.CheckSendFinish = CheckSendFinish
ArmyManager.GetMaxUnLockId = GetMaxUnLockId
ArmyManager.IsUnLock = IsUnLock
ArmyManager.GetLockTrainBuild = GetLockTrainBuild
ArmyManager.GetLockTrainScience = GetLockTrainScience
ArmyManager.IsCanUpgrade = IsCanUpgrade
ArmyManager.GetArmyList = GetArmyList
ArmyManager.GetMaxUpgradeId = GetMaxUpgradeId
ArmyManager.GetCanUnLockUpgrade = GetCanUnLockUpgrade
ArmyManager.GetArmyNumMax = GetArmyNumMax
ArmyManager.GetTotalArmyNum = GetTotalArmyNum
ArmyManager.GetTotalMarchArmyNum = GetTotalMarchArmyNum
ArmyManager.GetQueueArmyNum = GetQueueArmyNum
ArmyManager.GetTotalMarchAndFreeArmyNum = GetTotalMarchAndFreeArmyNum
ArmyManager.GetArmyDataForPve = GetArmyDataForPve
ArmyManager.GetArmyUnlock = GetArmyUnlock
ArmyManager.SaveArmyUnlock = SaveArmyUnlock
return ArmyManager
