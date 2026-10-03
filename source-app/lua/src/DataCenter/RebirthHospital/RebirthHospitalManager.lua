local RebirthHospitalManager = BaseClass("RebirthHospitalManager")
local RebirthHospitalInfo = require("DataCenter/RebirthHospital/RebirthHospitalInfo")
local Localization = CS.GameEntry.Localization

function RebirthHospitalManager:AddListeners()
  function self.FuncOnBuildInView(uid)
    self:OnBuildInView(uid)
  end
  
  function self.FuncOnQueueEnd(type)
    self:OnQueueEnd(type)
  end
  
  EventManager:GetInstance():AddListener(EventId.BUILD_IN_VIEW, self.FuncOnBuildInView)
  EventManager:GetInstance():AddListener(EventId.QUEUE_TIME_END, self.FuncOnQueueEnd)
end

function RebirthHospitalManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.BUILD_IN_VIEW, self.FuncOnBuildInView)
  EventManager:GetInstance():RemoveListener(EventId.QUEUE_TIME_END, self.FuncOnQueueEnd)
end

function RebirthHospitalManager:__init()
  self.nextRebirthTime = 0
  self.allRebirthHospitalInfo = {}
  self.historyInfoList = {}
  self:AddListeners()
end

function RebirthHospitalManager:__delete()
  self.nextRebirthTime = nil
  self.allRebirthHospitalInfo = nil
  self.historyInfoList = nil
  self:RemoveListener()
end

function RebirthHospitalManager:OnBuildInView(uid)
  local bUuid = tonumber(uid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData.itemId == BuildingTypes.LW_BUILDING_REBIRTH_HOSPITAL then
    local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.RebirthHospital)
    if queue ~= nil then
      self:ShowBuildHospitalEffect(buildData.pointId, queue:GetQueueState(), false)
    end
  end
end

function RebirthHospitalManager:OnQueueEnd(type)
  if type == NewQueueType.RebirthHospital then
    self:RefreshTreatmentEffect(true)
  end
end

function RebirthHospitalManager:GetRebirthCooldownDuration()
  return LuaEntry.Effect:GetGameEffect(EffectDefine.LW_REBIRTH_HOSPITAL_COOLDOWN_TIME)
end

function RebirthHospitalManager:GetRebirthCooldownLeftTime()
  if self.nextRebirthTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= self.nextRebirthTime then
      return -1
    end
    return self.nextRebirthTime - curTime
  end
  return -1
end

function RebirthHospitalManager:IsRebirthInCooldown()
  local leftTime = self:GetRebirthCooldownLeftTime()
  return 0 < leftTime
end

function RebirthHospitalManager:IsHaveCanRebirthSolider()
  local hasAnyDeadSoldier = false
  if self.allRebirthHospitalInfo ~= nil then
    for i, v in pairs(self.allRebirthHospitalInfo) do
      if v:GetDeadCount() > 0 then
        hasAnyDeadSoldier = true
      end
    end
  end
  return hasAnyDeadSoldier
end

function RebirthHospitalManager:IsShowBuildingBubbleFree()
  return self:IsHaveCanRebirthSolider() and not self:IsRebirthInCooldown()
end

function RebirthHospitalManager:GetMaxLevelSoldierDataInRebirth()
  local list = self:GetAllInRebirthSoldierList()
  if list ~= nil and 0 < #list then
    return DataCenter.SoldierDataManager:GetTemplate(tonumber(list[1].armyId))
  end
end

function RebirthHospitalManager:SoldierComparer(a, b)
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

function RebirthHospitalManager:ShowBuildHospitalEffect(pointId, state, isFromQueueEnd)
  if IsNull(CS.SceneManager.World) then
    return
  end
  local cityObj = CS.SceneManager.World:GetBuildingByPoint(pointId)
  if cityObj then
    local effectGo = cityObj.gameObject.transform:Find("ModelGo/EffectGo")
    local effectWorking = cityObj.gameObject.transform:Find("ModelGo/EffectGo/ZLParent")
    local effectFinish = cityObj.gameObject.transform:Find("ModelGo/EffectGo/QJParent")
    if effectGo and effectWorking and effectFinish then
      local isInstant = self:IsRebirthInstantDone()
      effectGo.gameObject:SetActive(state == NewQueueState.Work or state == NewQueueState.Finish and isInstant)
      effectWorking.gameObject:SetActive(state == NewQueueState.Work)
      effectFinish.gameObject:SetActive(state == NewQueueState.Finish and isInstant and isFromQueueEnd)
    end
  end
end

function RebirthHospitalManager:RefreshTreatmentEffect(isFromQueueEnd)
  local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.RebirthHospital)
  if not queue then
    return
  end
  local state = queue:GetQueueState()
  local buildId = DataCenter.BuildManager:GetBuildIdByNewQueue(NewQueueType.RebirthHospital)
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  for i = 1, #list do
    self:ShowBuildHospitalEffect(list[i].pointId, state, isFromQueueEnd)
  end
end

function RebirthHospitalManager:SetCurRebirthHospitalBuildUuid(buildUuid)
  self.buildUuid = buildUuid
end

function RebirthHospitalManager:GetCurRebirthHospitalBuildUuid()
  return self.buildUuid
end

function RebirthHospitalManager:CollectSolder(resetSoldierInfos)
  local uuid = DataCenter.RebirthHospitalManager:GetCurRebirthHospitalBuildUuid()
  if SceneUtils.GetIsInCity() then
    DataCenter.LWCityPerformNpcManager:GetUtil():HospitalCollectSolder(uuid, resetSoldierInfos)
  end
end

function RebirthHospitalManager:GetSoldierMaxCount()
  local count = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_REBIRTH_HOSPITAL_SOLDIER_COUNT_MAX)
  local factor = (LuaEntry.Effect:GetGameEffect(EffectDefine.LW_REBIRTH_HOSPITAL_SOLDIER_COUNT_FACTOR) or 0) * 100000
  factor = math.floor(100000 + factor + 0.5)
  count = count * factor / 100000
  return math.max(0, math.ceil(count))
end

function RebirthHospitalManager:GetSoldierCurCount()
  local res = 0
  if self.allRebirthHospitalInfo ~= nil then
    for i, v in pairs(self.allRebirthHospitalInfo) do
      res = res + v:GetDeadCount()
    end
  end
  return res
end

function RebirthHospitalManager:HandleServerRebirthData(message, clearCache)
  if message.nextRebirthTime ~= nil then
    self.nextRebirthTime = message.nextRebirthTime
  end
  if message.rebirthHospital ~= nil then
    if clearCache then
      self.allRebirthHospitalInfo = {}
    end
    local allData = message.rebirthHospital
    for k, v in pairs(allData) do
      self:UpdateSingleRebirthHospitalInfo(v)
    end
  end
end

function RebirthHospitalManager:UpdateSingleRebirthHospitalInfo(message)
  if message ~= nil then
    local armyId = message.armyId
    local info = self:GetRebirthHospitalInfoByArmyId(armyId)
    if info == nil then
      info = RebirthHospitalInfo.New()
      info:UpdateInfo(message)
      self.allRebirthHospitalInfo[tostring(armyId)] = info
    else
      info:UpdateInfo(message)
    end
  end
end

function RebirthHospitalManager:GetRebirthHospitalInfoByArmyId(armyId)
  if self.allRebirthHospitalInfo ~= nil then
    return self.allRebirthHospitalInfo[tostring(armyId)]
  end
end

function RebirthHospitalManager:GetAllRebirthHospitalInfo()
  return self.allRebirthHospitalInfo
end

function RebirthHospitalManager:GetAllDeadSoldierList()
  local worldId = LuaEntry.Player:GetCurWorldId()
  local allInfo = DataCenter.RebirthHospitalManager:GetAllRebirthHospitalInfo()
  local res = {}
  if allInfo ~= nil then
    for i, info in pairs(allInfo) do
      local dead = info:GetDeadCount()
      if 0 < dead then
        local soldierTemplate = info:GetSoldierTemplate()
        if soldierTemplate ~= nil and (worldId == 0 and soldierTemplate.type == 1 or 0 < worldId and soldierTemplate.type == 3) then
          table.insert(res, info)
        end
      end
    end
  end
  table.sort(res, function(a, b)
    return DataCenter.RebirthHospitalManager:SoldierComparer(a, b)
  end)
  return res
end

function RebirthHospitalManager:IsInRebirth()
  local soldierList = self:GetAllInRebirthSoldierList()
  return not table.IsNullOrEmpty(soldierList)
end

function RebirthHospitalManager:GetAllInRebirthSoldierList()
  local worldId = LuaEntry.Player:GetCurWorldId()
  local allInfo = DataCenter.RebirthHospitalManager:GetAllRebirthHospitalInfo()
  local res = {}
  if allInfo ~= nil then
    for i, info in pairs(allInfo) do
      local rebirthCount = info:GetRebirthCount()
      if 0 < rebirthCount then
        local soldierTemplate = info:GetSoldierTemplate()
        if soldierTemplate ~= nil and (worldId == 0 and soldierTemplate.type == 1 or 0 < worldId and soldierTemplate.type == 3) then
          table.insert(res, info)
        end
      end
    end
  end
  table.sort(res, function(a, b)
    return DataCenter.RebirthHospitalManager:SoldierComparer(a, b)
  end)
  return res
end

function RebirthHospitalManager:GetRebirthQueueInfo()
  return DataCenter.QueueDataManager:GetQueueByType(NewQueueType.RebirthHospital)
end

function RebirthHospitalManager:GetRebirthQueueLeftTime()
  local queue = self:GetRebirthQueueInfo()
  if queue ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = queue.endTime - curTime
    return leftTime
  end
  return -1
end

function RebirthHospitalManager:IsRebirthInstantDone()
  local queue = self:GetRebirthQueueInfo()
  if queue ~= nil then
    return queue.startTime == queue.endTime
  end
  return false
end

function RebirthHospitalManager:SendRebirthMessage(soldierInfo)
  SFSNetwork.SendMessage(MsgDefines.RebirthHospitalRebirth, soldierInfo)
end

function RebirthHospitalManager:OnRebirthPushMessageCallback(message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  self:HandleServerRebirthData(message, false)
  local rebirthSoldierInfos = {}
  local finishRebirth = 0
  if message.rebirthHospital ~= nil then
    local allData = message.rebirthHospital
    for k, v in pairs(allData) do
      if v.finishRebirth ~= nil and 0 < v.finishRebirth then
        table.insert(rebirthSoldierInfos, {
          id = tonumber(v.armyId),
          count = v.finishRebirth
        })
        finishRebirth = finishRebirth + v.finishRebirth
      end
    end
  end
  if not table.IsNullOrEmpty(rebirthSoldierInfos) then
    self:CollectSolder(rebirthSoldierInfos)
  end
  if 0 < finishRebirth then
    local rebirth = self:GetRebirthQueueFinishSoldierCount()
    if rebirth <= 0 then
      UIUtil.ShowTips(Localization:GetString("hospital_finish_tips", finishRebirth))
    else
      UIUtil.ShowTips(Localization:GetString("hospital_finish_drill_ground_tips", finishRebirth, rebirth))
    end
  end
  EventManager:GetInstance():Broadcast(EventId.RebirthHospitalUpdate)
end

function RebirthHospitalManager:OnRebirthMessageCallback(message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  if message.resource ~= nil then
    LuaEntry.Resource:UpdateResource(message.resource)
  end
  local itemId
  if message.queue ~= nil then
    local itemObj = message.queue.itemObj
    if itemObj ~= nil then
      itemId = itemObj.itemId
      DataCenter.QueueDataManager:UpdateQueueData(message.queue)
    end
  end
  if itemId ~= nil then
    local buildId = DataCenter.BuildManager:GetBuildIdByNewQueue(NewQueueType.RebirthHospital)
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
      EventManager:GetInstance():Broadcast(EventId.RebirthHospitalStart, signal)
    end
    self:RefreshTreatmentEffect(false)
  end
  self:HandleServerRebirthData(message)
  EventManager:GetInstance():Broadcast(EventId.RebirthHospitalUpdate)
end

function RebirthHospitalManager:GetRebirthQueueFinishSoldierCount()
  local worldId = LuaEntry.Player:GetCurWorldId()
  local count = 0
  for k, v in pairs(self.allRebirthHospitalInfo) do
    local soldierTemplate = v:GetSoldierTemplate()
    if soldierTemplate ~= nil and (worldId == 0 and soldierTemplate.type == 1 or 0 < worldId and soldierTemplate.type == 3) then
      count = count + v:GetRebirthCount()
    end
  end
  return count
end

function RebirthHospitalManager:CheckRebirthQueueFinish(uuid)
  local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.RebirthHospital)
  if queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
    local curHaveCount = DataCenter.SoldierDataManager:GetPlayerSoldiersTotalNum()
    local storeLimit = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SOLDIER_MAX_STOCK)
    if curHaveCount >= math.modf(storeLimit) then
      UIUtil.ShowTips(Localization:GetString("hospital_finish_drill_ground_full_tips", self:GetRebirthQueueFinishSoldierCount()))
      return false
    end
    self:SetCurRebirthHospitalBuildUuid(uuid)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.HospitalCollectSoldier, false)
    SFSNetwork.SendMessage(MsgDefines.QueueFinish, {
      uuid = queue.uuid
    })
    return true
  end
  return false
end

function RebirthHospitalManager:OnRebirthHistoryMessageCallback(msg)
  if msg ~= nil and msg.rebirthHospitalRecord ~= nil then
    self.historyInfoList = msg.rebirthHospitalRecord
    if self.historyInfoList ~= nil then
      table.sort(self.historyInfoList, function(a, b)
        if a.recordTime ~= nil and b.recordTime ~= nil then
          return a.recordTime > b.recordTime
        end
        return false
      end)
    end
    EventManager:GetInstance():Broadcast(EventId.RebirthHospitalHistoryUpdate)
  end
end

function RebirthHospitalManager:GetHistoryInfoList()
  return self.historyInfoList
end

return RebirthHospitalManager
