local HospitalManager = BaseClass("HospitalManager")
local tostring = _ENV.tostring
local CS = _ENV.CS
local Localization = CS.GameEntry.Localization
local DataCenter = _ENV.DataCenter
local CommonUtil = _ENV.CommonUtil
local cacheKey = SettingKeys.HOSPITAL_CURE_SOLDIER_TIME

local function AddListeners(self)
  EventManager:GetInstance():AddListener(EventId.BUILD_IN_VIEW, self.OnBuildInView)
  EventManager:GetInstance():AddListener(EventId.QUEUE_TIME_END, self.OnQueueEnd)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.BUILD_IN_VIEW, self.OnBuildInView)
  EventManager:GetInstance():RemoveListener(EventId.QUEUE_TIME_END, self.OnQueueEnd)
end

local function __init(self)
  self.allHospital = {}
  AddListeners(self)
end

local function __delete(self)
  self.allHospital = nil
  RemoveListener(self)
end

local function ShowBuildHospitalEffect(pointId, state)
  if IsNull(CS.SceneManager.World) then
    return
  end
  local cityObj = CS.SceneManager.World:GetBuildingByPoint(pointId)
  if cityObj then
    local effectGo = cityObj.gameObject.transform:Find("ModelGo/EffectGo")
    local effectEffParent = cityObj.gameObject.transform:Find("ModelGo/EffectGo/EffParent")
    if effectGo and effectEffParent then
      effectGo.gameObject:SetActive(state == NewQueueState.Work)
      effectEffParent.gameObject:SetActive(state == NewQueueState.Work)
    end
  end
end

local function OnBuildInView(uid)
  local bUuid = tonumber(uid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData.itemId == BuildingTypes.LW_BUILD_HOSPITL then
    local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
    ShowBuildHospitalEffect(buildData.pointId, queue:GetQueueState())
  end
end

local function RefreshTreatmentEffect()
  local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
  if not queue then
    return
  end
  local state = queue:GetQueueState()
  local buildId = DataCenter.BuildManager:GetBuildIdByNewQueue(NewQueueType.Hospital)
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  for i = 1, #list do
    ShowBuildHospitalEffect(list[i].pointId, state)
  end
end

local function OnQueueEnd(type)
  if type == NewQueueType.Hospital then
    RefreshTreatmentEffect()
  end
end

local function InitData(self, message)
  if message.hospital ~= nil then
    self.allHospital = {}
    for k, v in pairs(message.hospital) do
      self:UpdateOneHospitalInfo(v)
    end
  end
end

local function UpdateOneHospitalInfo(self, message)
  if message ~= nil then
    local id = message.armyId
    local one = self:FindHospitalInfo(id)
    if one == nil then
      one = HospitalInfo.New()
      one:UpdateInfo(message)
      self.allHospital[id] = one
    else
      one:UpdateInfo(message)
    end
    if one ~= nil and one.dead == 0 and one.heal == 0 then
      self.allHospital[id] = nil
    end
  end
end

local function FindHospitalInfo(self, id)
  return self.allHospital[tostring(id)]
end

local function GetAllHospital(self)
  local result = {}
  local worldId = LuaEntry.Player:GetCurWorldId()
  for k, v in pairs(self.allHospital) do
    if v.dead > 0 or 0 < v.heal then
      local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(v.armyId)
      if soldierTemplate ~= nil and (worldId == 0 and soldierTemplate.type == 1 or 0 < worldId and soldierTemplate.type == 3) then
        table.insert(result, v)
      end
    end
  end
  table.sort(result, self.SortHospitalSoldier)
  return result
end

local function GetDeadHospital(self)
  local result = {}
  local worldId = LuaEntry.Player:GetCurWorldId()
  for k, v in pairs(self.allHospital) do
    if v.dead > 0 then
      local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(v.armyId)
      if soldierTemplate ~= nil and (worldId == 0 and soldierTemplate.type == 1 or 0 < worldId and soldierTemplate.type == 3) then
        table.insert(result, v)
      end
    end
  end
  table.sort(result, self.SortHospitalSoldier)
  return result
end

local function GetTreatingHospital(self)
  local result = {}
  local worldId = LuaEntry.Player:GetCurWorldId()
  for k, v in pairs(self.allHospital) do
    if v.heal > 0 then
      local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(v.armyId)
      if soldierTemplate ~= nil and (worldId == 0 and soldierTemplate.type == 1 or 0 < worldId and soldierTemplate.type == 3) then
        table.insert(result, v)
      end
    end
  end
  table.sort(result, self.SortHospitalSoldier)
  return result
end

local function SortHospitalSoldier(a, b)
  local army1 = DataCenter.SoldierDataManager:GetTemplate(a.armyId)
  local army2 = DataCenter.SoldierDataManager:GetTemplate(b.armyId)
  if army1 == nil then
    return false
  elseif army2 == nil then
    return true
  elseif army1.lv > army2.lv then
    return true
  elseif army1.lv < army2.lv then
    return false
  else
    local id1 = army1.id
    local id2 = army2.id
    if id1 > id2 then
      return true
    elseif id1 < id2 then
      return false
    end
  end
  return false
end

local function GetHospitalCount(self)
  local result = 0
  local worldId = LuaEntry.Player:GetCurWorldId()
  for k, v in pairs(self.allHospital) do
    local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(v.armyId)
    if soldierTemplate ~= nil and (worldId == 0 and soldierTemplate.type == 1 or 0 < worldId and soldierTemplate.type == 3) then
      result = result + v.heal
      result = result + v.dead
      if v.heal == nil or 0 < v.heal then
      end
    end
  end
  return result
end

local function CollectSolder(resetSoldierInfos)
  local uuid = DataCenter.HospitalManager:GetCurHospitalBuildUuid()
  if SceneUtils.GetIsInCity() then
    DataCenter.LWCityPerformNpcManager:GetUtil():HospitalCollectSolder(uuid, resetSoldierInfos)
  end
end

local function GetHospitalMaxCount(self)
  return math.floor(LuaEntry.Effect:GetGameEffect(EffectDefine.TREAT_NUM_MAX_EFFECT_ADD) * (1 + LuaEntry.Effect:GetGameEffect(EffectDefine.HOS_MAX) / 100))
end

local function HospitalCureHandle(self, message)
  if message.errorCode == nil then
    if message.resource ~= nil then
      LuaEntry.Resource:UpdateResource(message.resource)
    end
    if message.gold ~= nil then
      LuaEntry.Player.gold = message.gold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    local itemId
    local queue = message.queue
    if queue ~= nil then
      local itemObj = queue.itemObj
      if itemObj ~= nil then
        itemId = itemObj.itemId
        DataCenter.QueueDataManager:UpdateQueueData(queue)
      end
    end
    if message.army ~= nil then
      for k, v in pairs(message.army) do
        DataCenter.ArmyManager:UpdateOneArmy(v)
      end
      UIUtil.ShowTipsId(130127)
    end
    if message.hospitalArray ~= nil then
      for k, v in pairs(message.hospitalArray) do
        self:UpdateOneHospitalInfo(v)
      end
      EventManager:GetInstance():Broadcast(EventId.HospitalUpdate)
    end
    if itemId ~= nil then
      local buildId = DataCenter.BuildManager:GetBuildIdByNewQueue(NewQueueType.Hospital)
      local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
      local tiles = BuildTilesSize.One
      local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
      if template ~= nil then
        tiles = template.tileX
      end
      if list ~= nil then
        local aboutBuilds = SFSArray.New()
        for k, v in pairs(list) do
          local signal1 = SFSObject.New()
          signal1:PutLong("bUuid", v.uuid)
          aboutBuilds:AddSFSObject(signal1)
        end
        local signal = SFSObject.New()
        signal:PutSFSArray("aboutBuilds", aboutBuilds)
        EventManager:GetInstance():Broadcast(EventId.HospitaiStart, signal)
      end
      RefreshTreatmentEffect()
    end
    if message.itemId or message.goldForTime or message.goldForResource then
      local resetSoldierInfos = {}
      local realCure = message.cure
      for i, v in pairs(message.hospitalArray) do
        table.insert(resetSoldierInfos, {
          id = tonumber(v.armyId),
          count = message.cure
        })
      end
      CollectSolder(resetSoldierInfos)
      self:ShowCureTip(realCure)
      EventManager:GetInstance():Broadcast(EventId.InstantCureFinish)
    end
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  end
end

local function ResetHospitalInfo(self, id)
  local temp = self:FindHospitalInfo(id)
  if temp ~= nil then
    if temp.dead <= 0 then
      self.allHospital[id] = nil
    else
      temp.heal = 0
    end
  end
end

local function UpdateHospitalHealInfo(self, id, cure)
  local hospitalInfo = self:FindHospitalInfo(id)
  if hospitalInfo ~= nil then
    hospitalInfo.heal = hospitalInfo.heal - cure
    if hospitalInfo.heal <= 0 and 0 >= hospitalInfo.dead then
      self.allHospital[id] = nil
    end
  end
end

local function UpdateHospitalDeadInfo(self, id, dead)
  local hospitalInfo = self:FindHospitalInfo(id)
  if hospitalInfo ~= nil then
    local oldNum = hospitalInfo.dead
    hospitalInfo.dead = dead
    if hospitalInfo.heal <= 0 and hospitalInfo.dead <= 0 then
      self.allHospital[id] = nil
    end
    return oldNum - dead
  end
  return 0
end

local function UpdateRebuildHospitalHealInfo(self, id, cure, dead)
  local message = {
    armyId = id,
    heal = cure,
    dead = dead
  }
  local hospitalInfo = self:FindHospitalInfo(message.armyId)
  if hospitalInfo == nil then
    hospitalInfo = HospitalInfo.New()
    hospitalInfo:UpdateInfo(message)
    self.allHospital[id] = hospitalInfo
  else
    hospitalInfo:UpdateInfo(message)
  end
  if hospitalInfo ~= nil and hospitalInfo.dead == 0 and hospitalInfo.heal == 0 then
    self.allHospital[id] = nil
  end
end

local function SetCurHospitalBuildUuid(self, buildUuid)
  self.buildUuid = buildUuid
end

local function GetCurHospitalBuildUuid(self, buildUuid)
  return self.buildUuid
end

local function PushHospitalChangeHandle(self, message)
  local resetSoldierInfos = {}
  local realCure = 0
  local bBattleField = message.battleField == true
  if message.hospital ~= nil then
    for k, v in pairs(message.hospital) do
      if v.cure ~= nil and v.armyId ~= nil and v.dead ~= nil then
        self:UpdateRebuildHospitalHealInfo(v.armyId, v.cure, v.dead)
      elseif v.cure ~= nil and v.armyId ~= nil then
        self:UpdateHospitalHealInfo(v.armyId, v.cure)
        table.insert(resetSoldierInfos, {
          id = tonumber(v.armyId),
          count = v.cure
        })
        realCure = realCure + v.cure
      elseif bBattleField and v.dead ~= nil and v.armyId ~= nil then
        realCure = realCure + self:UpdateHospitalDeadInfo(v.armyId, v.dead)
      else
        self:UpdateOneHospitalInfo(v)
      end
    end
  end
  CollectSolder(resetSoldierInfos)
  if bBattleField then
    if BattleFieldUtil.InBattleField() then
      BattleFieldUtil.PlaySoliderNumChange(false, LuaEntry.Player:GetBattleFieldPos(), realCure)
    end
  else
    self:ShowCureTip(realCure)
  end
  EventManager:GetInstance():Broadcast(EventId.HospitalUpdate)
end

local function IsHaveInjuredSolider(self)
  local worldId = LuaEntry.Player:GetCurWorldId()
  for k, v in pairs(self.allHospital) do
    if v.dead > 0 then
      local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(v.armyId)
      if soldierTemplate ~= nil and (worldId == 0 and soldierTemplate.type == 1 or 0 < worldId and soldierTemplate.type == 3) then
        return true
      end
    end
  end
  return false
end

local function GetHealCount(self)
  local worldId = LuaEntry.Player:GetCurWorldId()
  local count = 0
  for k, v in pairs(self.allHospital) do
    local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(v.armyId)
    if soldierTemplate ~= nil and (worldId == 0 and soldierTemplate.type == 1 or 0 < worldId and soldierTemplate.type == 3) then
      count = count + v.heal
    end
  end
  return count
end

local function CheckSendFinish(self, uuid)
  local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
  if queue ~= nil and (queue:GetQueueState() == NewQueueState.Finish or DataCenter.CityRebuildDataManager:GetCureState()) then
    local curHaveCount = DataCenter.SoldierDataManager:GetPlayerSoldiersTotalNum()
    local storeLimit = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SOLDIER_MAX_STOCK)
    if curHaveCount >= math.modf(storeLimit) then
      UIUtil.ShowTips(Localization:GetString("hospital_finish_drill_ground_full_tips", DataCenter.HospitalManager:GetHealCount()))
      return false
    end
    SetCurHospitalBuildUuid(self, uuid)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.HospitalCollectSoldier, false)
    SFSNetwork.SendMessage(MsgDefines.QueueFinish, {
      uuid = queue.uuid
    })
    return true
  end
  return false
end

local function GetMaxSoldierInTreating(self)
  local list = self:GetTreatingHospital()
  if list ~= nil and 0 < #list then
    return DataCenter.SoldierDataManager:GetTemplate(tonumber(list[1].armyId))
  end
end

local function GetSoldierCureValueLocal(self)
  local localTimeStr = CommonUtil.PlayerPrefsGetString(cacheKey, "-1.0")
  return tonumber(localTimeStr)
end

local function SetSoldierCureTimeValueLocal(self, value)
  if value then
    CommonUtil.PlayerPrefsSetString(cacheKey, tostring(value))
  end
end

local function CalculateCureTime2Count(self, time, cureTime)
  local healSpeedUp = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_HOSPITAL_HEALSPEEDUP)
  healSpeedUp = healSpeedUp or 0
  local newTime = time * (1 + healSpeedUp)
  local dragonSpeedUp
  if BattleFieldUtil.InBattleField(BattleFieldType.Desert) then
    dragonSpeedUp = BattleFieldUtil.GetEffectById(EffectDefine.LW_DRAGON_SOLDIER_HOSPITAL_SPEED_ADD_PERCENT)
  elseif BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
    dragonSpeedUp = BattleFieldUtil.GetEffectById(EffectDefine.LW_EFF_EPIDEMIC_HOSPITAL_SPEED_ADD)
  end
  if dragonSpeedUp ~= nil and dragonSpeedUp ~= 0 then
    newTime = newTime * (1 + dragonSpeedUp * 1.0E-4)
  end
  local number = newTime / cureTime
  local result = math.floor(number)
  local t = HospitalManager.CalculateCount2CureTime(self, result + 1, cureTime)
  local dif = t - time
  if -1.0E-5 <= dif and dif <= 1.0E-5 then
    return result + 1, 0
  end
  return result, time - HospitalManager.CalculateCount2CureTime(self, result, cureTime)
end

local function CalculateCount2CureTime(self, count, cureTime)
  local time = cureTime * count
  local healSpeedUp = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_HOSPITAL_HEALSPEEDUP)
  healSpeedUp = healSpeedUp or 0
  time = time / (1 + healSpeedUp)
  local dragonSpeedUp
  if BattleFieldUtil.InBattleField(BattleFieldType.Desert) then
    dragonSpeedUp = BattleFieldUtil.GetEffectById(EffectDefine.LW_DRAGON_SOLDIER_HOSPITAL_SPEED_ADD_PERCENT)
  elseif BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
    dragonSpeedUp = BattleFieldUtil.GetEffectById(EffectDefine.LW_EFF_EPIDEMIC_HOSPITAL_SPEED_ADD)
  end
  if dragonSpeedUp ~= nil and dragonSpeedUp ~= 0 then
    time = time / (1 + dragonSpeedUp * 1.0E-4)
  end
  if time < 0 then
    time = -1.0
  elseif 0 < time and time < 1 then
    time = 1.0
  end
  return time
end

local function ShowCureTip(self, realCure)
  if 0 < realCure then
    local healCount = DataCenter.HospitalManager:GetHealCount()
    if healCount <= 0 then
      UIUtil.ShowTips(Localization:GetString("hospital_finish_tips", realCure))
    else
      UIUtil.ShowTips(Localization:GetString("hospital_finish_drill_ground_tips", realCure, healCount))
    end
  end
end

local function GetHospitalMaxVolume(self)
  return math.modf(LuaEntry.Effect:GetGameEffect(EffectDefine.LW_HOSPITAL_MAX_STOCK))
end

local function GetMaxDeadSoldier(self)
  local maxNumber = 0
  local worldId = LuaEntry.Player:GetCurWorldId()
  for k, v in pairs(self.allHospital) do
    if 0 < v.dead then
      local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(v.armyId)
      if soldierTemplate ~= nil and (worldId == 0 and soldierTemplate.type == 1 or 0 < worldId and soldierTemplate.type == 3) and v.dead then
        maxNumber = maxNumber + v.dead
      end
    end
  end
  return maxNumber
end

HospitalManager.__init = __init
HospitalManager.__delete = __delete
HospitalManager.InitData = InitData
HospitalManager.UpdateOneHospitalInfo = UpdateOneHospitalInfo
HospitalManager.FindHospitalInfo = FindHospitalInfo
HospitalManager.GetAllHospital = GetAllHospital
HospitalManager.GetHospitalCount = GetHospitalCount
HospitalManager.GetHospitalMaxCount = GetHospitalMaxCount
HospitalManager.GetTreatingHospital = GetTreatingHospital
HospitalManager.SortHospitalSoldier = SortHospitalSoldier
HospitalManager.HospitalCureHandle = HospitalCureHandle
HospitalManager.PushHospitalChangeHandle = PushHospitalChangeHandle
HospitalManager.ResetHospitalInfo = ResetHospitalInfo
HospitalManager.IsHaveInjuredSolider = IsHaveInjuredSolider
HospitalManager.CheckSendFinish = CheckSendFinish
HospitalManager.GetMaxSoldierInTreating = GetMaxSoldierInTreating
HospitalManager.GetDeadHospital = GetDeadHospital
HospitalManager.GetHealCount = GetHealCount
HospitalManager.SetCurHospitalBuildUuid = SetCurHospitalBuildUuid
HospitalManager.GetCurHospitalBuildUuid = GetCurHospitalBuildUuid
HospitalManager.RefreshTreatmentEffect = RefreshTreatmentEffect
HospitalManager.OnBuildInView = OnBuildInView
HospitalManager.OnQueueEnd = OnQueueEnd
HospitalManager.UpdateHospitalHealInfo = UpdateHospitalHealInfo
HospitalManager.UpdateHospitalDeadInfo = UpdateHospitalDeadInfo
HospitalManager.GetSoldierCureValueLocal = GetSoldierCureValueLocal
HospitalManager.SetSoldierCureTimeValueLocal = SetSoldierCureTimeValueLocal
HospitalManager.CalculateCureTime2Count = CalculateCureTime2Count
HospitalManager.CalculateCount2CureTime = CalculateCount2CureTime
HospitalManager.ShowCureTip = ShowCureTip
HospitalManager.UpdateRebuildHospitalHealInfo = UpdateRebuildHospitalHealInfo
HospitalManager.GetHospitalMaxVolume = GetHospitalMaxVolume
HospitalManager.GetMaxDeadSoldier = GetMaxDeadSoldier
return HospitalManager
