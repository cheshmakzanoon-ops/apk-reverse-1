local BuildQueueManager = BaseClass("BuildQueueManager")
local BuildQueueGuide = require("DataCenter/BuildQueueManager/BuildQueueGuide")
BuildQueueInfo = require("DataCenter/BuildQueueManager/BuildQueueInfo")

function BuildQueueManager:Startup()
end

function BuildQueueManager:InitQueueConfigList(buildQueueList)
  if buildQueueList ~= nil then
    self.queueConfig = DeepCopy(buildQueueList)
  end
end

function BuildQueueManager:GetUnlockQueueByIndex(index)
  return self.queueConfig[index]
end

function BuildQueueManager:UpdateQueueData(queueList, isFirstInit)
  if table.IsNullOrEmpty(queueList) then
    return
  end
  for _, q in pairs(queueList) do
    if q.type == LWBuildQueueType.NORMAL or q.type == LWBuildQueueType.SPECIAL then
      local uuid = q.uuid
      if not uuid then
        uuid = q.id
      elseif q.qid then
        self.allQueueList[q.qid] = nil
      end
      if self.allQueueList[uuid] then
        self.allQueueList[uuid]:ParseData(q)
      else
        local buildQueueData = BuildQueueInfo.New()
        buildQueueData:ParseData(q)
        self.allQueueList[uuid] = buildQueueData
      end
      local queueData = self.allQueueList[uuid]
      if queueData then
        if queueData:IsUnlocked() then
          self.unlockedQueueList[queueData.uuid] = queueData
        else
          self.unlockedQueueList[queueData.uuid] = nil
        end
        if queueData:IsRentQueue() and not queueData:IsExpired() then
          self.haveRentQueue = true
        end
      end
      if q.uT then
        DataCenter.BuildManager:UpdateBuildingTimeByUuid(queueData.occupyUuid, q.uT)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshUIBuildQueue)
end

function BuildQueueManager:RemoveQueueData(queueList)
  if table.IsNullOrEmpty(queueList) then
    return
  end
  local removeRentQueue = false
  for _, q in pairs(queueList) do
    if q and q.uuid then
      local uuid = q.uuid
      self.allQueueList[uuid] = nil
      self.unlockedQueueList[uuid] = nil
      if self.allQueueList[uuid] and self.allQueueList[uuid]:IsRentQueue() then
        removeRentQueue = true
      end
    end
  end
  if removeRentQueue then
    self.haveRentQueue = false
    for _, queueData in pairs(self.allQueueList) do
      if queueData and queueData:IsRentQueue() and not queueData:IsExpired() then
        self.haveRentQueue = true
        break
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshUIBuildQueue)
end

function BuildQueueManager:FilterRentQueue()
  if table.IsNullOrEmpty(self.unlockedQueueList) then
    return
  end
  local haveRentQueue = false
  for uuid, queueData in pairs(self.unlockedQueueList) do
    if queueData and queueData:IsRentQueue() and not queueData:IsExpired() then
      haveRentQueue = true
    end
  end
  if self.haveRentQueue ~= haveRentQueue then
    EventManager:GetInstance():Broadcast(EventId.RefreshUIBuildQueue)
  end
  self.haveRentQueue = haveRentQueue
end

function BuildQueueManager:Refresh()
  self:CheckAllQueueTimeFinish()
  self:CheckAllFixQueueTimeFinish()
  self:CheckAlNoCostFixQueueTimeFinish()
  if self.haveRentQueue then
    self:FilterRentQueue()
  end
  if self.isInUnlimitedMode then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= self.specialQEndts then
      self:OnUpdateEffect()
      EventManager:GetInstance():Broadcast(EventId.RefreshUIBuildQueue)
    end
  end
end

function BuildQueueManager:ResetQueue(uuid)
  if uuid then
    local quequeueData = DataCenter.BuildQueueManager:GetQueueDataByBuildUuid(uuid)
    if quequeueData then
      quequeueData:ResetQueue()
    end
    self.timeFinishFlag[uuid] = nil
    self.heroFreeTimeDict[uuid] = nil
  end
end

function BuildQueueManager:GetQueueDataByBuildUuid(bUuid)
  local bUuidNum = tonumber(bUuid)
  if table.IsNullOrEmpty(self.unlockedQueueList) then
    return nil
  end
  for uuid, queueData in pairs(self.unlockedQueueList) do
    if queueData and queueData.occupyUuid == bUuidNum then
      return queueData
    end
  end
  return nil
end

function BuildQueueManager:GetQueueDataById(id)
  if table.IsNullOrEmpty(self.allQueueList) then
    return nil
  end
  for uuid, queueData in pairs(self.allQueueList) do
    if queueData and queueData.id == id then
      return queueData
    end
  end
  return nil
end

function BuildQueueManager:GetQueueDataByIndex(index)
end

function BuildQueueManager:GetQueueConfigList()
  return self.queueConfig
end

function BuildQueueManager:GetAllQueueUuid()
  return nil
end

function BuildQueueManager:SetWillUpgradeParam(param)
  self.willUpgradeParam = param
end

function BuildQueueManager:GetWillUpgradeParam()
  return self.willUpgradeParam
end

function BuildQueueManager:ClearWillUpgradeParam()
  self.willUpgradeParam = nil
end

function BuildQueueManager:SetTimeFinishFlag(bUuid)
  self.timeFinishFlag[bUuid] = true
end

function BuildQueueManager:SetCanUseHeroFreeTime(uuid)
  for i, v in pairs(self.heroFreeTimeDict) do
    if v[1] == uuid then
      v[2] = true
    end
  end
end

function BuildQueueManager:GetCanUseHeroFreeTime(uuid)
  for i, v in pairs(self.heroFreeTimeDict) do
    if v[1] == uuid then
      return v
    end
  end
  return nil
end

function BuildQueueManager:__init()
  self.fixQueueList = {}
  self.timer_action = BindCallback(self, self.Refresh)
  self.onBuildUpdate_action = BindCallback(self, self.OnBuildUpdateSignal)
  self.onBuildFinish_action = BindCallback(self, self.OnBuildUpgradeFinishSignal)
  self.onBuildFixUpgradeStart_action = BindCallback(self, self.OnBuildFixUpgradeStartSignal)
  self.onBuildFixUpgradeFinish_action = BindCallback(self, self.OnBuildFixUpgradeFinishSignal)
  self.updateEffectCallback = BindCallback(self, self.OnUpdateEffect)
  self:AddListener()
  self.queueConfig = {}
  self.willUpgradeParam = nil
  self.timeFinishFlag = {}
  self.heroFreeTimeDict = {}
  self.fixTimeFinishFlag = {}
  self.allQueueList = {}
  self.unlockedQueueList = {}
  self.specialQEndts = 0
  self.haveRentQueue = false
  self.noCostQueue = {}
  self.noCostTimeFinishFlag = {}
  self.isInUnlimitedMode = false
  self:AddTimer()
end

function BuildQueueManager:__delete()
  self:DeleteTimer()
  self.fixQueueList = nil
  self:RemoveListener()
  self.willUpgradeParam = nil
  self.timeFinishFlag = nil
  self.heroFreeTimeDict = nil
  self.fixTimeFinishFlag = nil
  self.allQueueList = nil
  self.unlockedQueueList = nil
  self.specialQEndts = nil
  self.haveRentQueue = nil
  self.noCostQueue = nil
  self.noCostTimeFinishFlag = nil
  self.isInUnlimitedMode = nil
  self.timer_action = nil
  self.onBuildUpdate_action = nil
  self.onBuildFinish_action = nil
  self.onBuildFixUpgradeStart_action = nil
  self.onBuildFixUpgradeFinish_action = nil
  self.updateEffectCallback = nil
end

function BuildQueueManager:InitQueueList(message)
  if message.queue_new then
    self.specialQEndts = 0
    self.allQueueList = {}
    self.unlockedQueueList = {}
    self:UpdateQueueData(message.queue_new, true)
  end
end

function BuildQueueManager:IsInUnlimitedMode()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.specialQEndts = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_UNLIMIT_BUILD_QUEUE)
  if curTime >= self.specialQEndts then
    self.specialQEndts = 0
  end
  self.isInUnlimitedMode = self.specialQEndts > 0
  if not self.specialQEndts or self.specialQEndts <= 0 then
    return false
  else
    return true
  end
end

function BuildQueueManager:OnUpdateEffect()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.specialQEndts = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_UNLIMIT_BUILD_QUEUE)
  if curTime >= self.specialQEndts then
    self.specialQEndts = 0
  end
  self.isInUnlimitedMode = self.specialQEndts > 0
end

function BuildQueueManager:IsViewInUnlimitedMode()
  local isInUnlimitedMode = self:IsInUnlimitedMode()
  if isInUnlimitedMode then
    return true
  else
    if not table.IsNullOrEmpty(self.unlockedQueueList) then
      for uuid, queueInfo in pairs(self.unlockedQueueList) do
        if queueInfo:IsSpecialQueue() then
          return true
        end
      end
    end
    return false
  end
end

function BuildQueueManager:GetFreeQueueUuid()
  local isUnlimitedMode = self:IsInUnlimitedMode()
  if isUnlimitedMode then
    return 1
  elseif not table.IsNullOrEmpty(self.unlockedQueueList) then
    for uuid, queueInfo in pairs(self.unlockedQueueList) do
      if queueInfo and queueInfo:IsFreeQueueToUse() then
        return uuid
      end
    end
  end
  return 0
end

function BuildQueueManager:IsCanUpgrade(buildId, level)
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if 0 < level then
    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
    if levelTemplate ~= nil and (levelTemplate.no_queue == BuildNoQueue.Yes or template.scan ~= BuildScanAnim.Play and levelTemplate:GetBuildTime() == 0) then
      return true, 0
    end
  elseif template ~= nil and (template.no_queue == BuildNoQueue.Yes or template.scan ~= BuildScanAnim.Play and template:GetBuildTime() == 0) then
    return true, 0
  end
  local freeQueueUuid = self:GetFreeQueueUuid()
  return 0 < freeQueueUuid, freeQueueUuid
end

function BuildQueueManager:GetAllCanUseQueueNum()
  if table.IsNullOrEmpty(self.unlockedQueueList) then
    return 0
  else
    local num = 0
    for uuid, queueInfo in pairs(self.unlockedQueueList) do
      if queueInfo and queueInfo:CanUse() then
        num = num + 1
      end
    end
    return num
  end
end

function BuildQueueManager:GetAllQueue()
  return DeepCopy(self.allQueueList)
end

function BuildQueueManager:GetOccupideQueueNum()
  if table.IsNullOrEmpty(self.unlockedQueueList) then
    return 0
  else
    local num = 0
    for uuid, queueInfo in pairs(self.unlockedQueueList) do
      if queueInfo and not queueInfo:IsFinish() then
        num = num + 1
      end
    end
    return num
  end
end

function BuildQueueManager:OnBuildUpgradeFinishSignal(data)
  if data ~= nil then
    local uuid = tonumber(data)
    if uuid ~= 0 then
      DataCenter.BuildQueueManager:ResetQueue(uuid)
      EventManager:GetInstance():Broadcast(EventId.RefreshUIBuildQueue)
      local noCostQueue = DataCenter.BuildQueueManager:GetNoCostQueueDataByBuildUuid(uuid)
      if noCostQueue then
        self:RemoveNoCostQueue(uuid)
      end
    end
  end
end

function BuildQueueManager:OnBuildUpdateSignal(data)
  if data ~= nil then
    local uuid = tonumber(data)
    if uuid ~= 0 then
      DataCenter.BuildQueueManager:CheckAllQueueTimeFinish()
      DataCenter.BuildQueueManager:CheckAllFixQueueTimeFinish()
      DataCenter.BuildQueueManager:CheckAlNoCostFixQueueTimeFinish()
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
      if buildData ~= nil and 0 < buildData.updateTime then
        if buildData.level == 0 then
          local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
          if template == nil then
            return
          end
          if template.no_queue == BuildNoQueue.Yes then
            self:AddNoCostQueue(uuid)
            return
          end
        else
          local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
          if template == nil then
            return
          end
          if template.no_queue == BuildNoQueue.Yes then
            self:AddNoCostQueue(uuid)
            return
          end
        end
        EventManager:GetInstance():Broadcast(EventId.RefreshUIBuildQueue)
      else
        DataCenter.BuildQueueManager:ResetQueue(uuid)
        local noCostQueue = DataCenter.BuildQueueManager:GetNoCostQueueDataByBuildUuid(uuid)
        if noCostQueue then
          self:RemoveNoCostQueue(uuid)
        end
      end
    end
  end
end

function BuildQueueManager:OnBuildFixUpgradeStartSignal(data)
  local uuid = 0
  if data:ContainsKey("bUuid") then
    uuid = data:GetLong("bUuid")
  end
  if uuid ~= 0 then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
    if buildData ~= nil and 0 < buildData.destroyEndTime then
      DataCenter.BuildQueueManager:AddFixQueue(uuid)
    end
  end
end

function BuildQueueManager:OnBuildFixUpgradeFinishSignal(data)
  if data ~= nil then
    local uuid = tonumber(data)
    if uuid ~= 0 then
      DataCenter.BuildQueueManager:RemoveFixQueue(uuid)
    end
  end
end

function BuildQueueManager:AddFixQueue(uuid)
  self.fixQueueList[uuid] = true
end

function BuildQueueManager:RemoveFixQueue(uuid)
  self.fixQueueList[uuid] = nil
  self.fixTimeFinishFlag[uuid] = nil
end

function BuildQueueManager:IsFixQueueTimeFinish(bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData ~= nil and buildData:IsFixFinish() then
    return true
  end
  return false
end

function BuildQueueManager:CheckAllFixQueueTimeFinish()
  local removeList = {}
  for k, v in pairs(self.fixQueueList) do
    if self.fixTimeFinishFlag[k] == nil then
      if self:IsFixQueueTimeFinish(k) then
        removeList[k] = true
        self.fixTimeFinishFlag[k] = true
        EventManager:GetInstance():Broadcast(EventId.Build_Fix_Time_End, k)
      end
    else
      removeList[k] = true
    end
  end
  for k, v in pairs(removeList) do
    self:RemoveFixQueue(k)
  end
end

function BuildQueueManager:AddNoCostQueue(uuid)
  self.noCostQueue[uuid] = true
end

function BuildQueueManager:RemoveNoCostQueue(uuid)
  self.noCostQueue[uuid] = nil
  self.noCostTimeFinishFlag[uuid] = nil
end

function BuildQueueManager:GetNoCostQueueDataByBuildUuid(uuid)
  return self.noCostQueue[uuid]
end

function BuildQueueManager:IsNoCostQueueTimeFinish(bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData ~= nil and buildData:IsUpgradeFinish() then
    return true
  end
  return false
end

function BuildQueueManager:CheckAlNoCostFixQueueTimeFinish()
  for uuid, _ in pairs(self.noCostQueue) do
    if uuid and self.noCostTimeFinishFlag[uuid] == nil and self:IsNoCostQueueTimeFinish(uuid) then
      self.noCostTimeFinishFlag[uuid] = true
      if not IsNull(CS.SceneManager.World) and CS.SceneManager:IsSceneBuildFninsh() == true then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
        if buildData ~= nil and buildData.destroyStartTime <= 0 then
          local city = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
          if city ~= nil then
            city:ChangeToBox()
          end
        end
        EventManager:GetInstance():Broadcast(EventId.Build_Time_End, uuid)
        EventManager:GetInstance():Broadcast(EventId.GF_building_upgrade_time_over, buildData)
      end
    end
  end
end

function BuildQueueManager:IsQueueTimeFinish(data)
  if data:IsFreeQueue() then
    return true
  end
  return false
end

function BuildQueueManager:CheckAllQueueTimeFinish()
  local theWorld = CS.SceneManager.World
  local sceneBuildFinish = CS.SceneManager:IsSceneBuildFninsh()
  for k, v in pairs(self.unlockedQueueList) do
    if v then
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v.occupyUuid)
      if buildData ~= nil and buildData.isWorldBuild and buildData.destroyStartTime <= 0 and self:IsQueueTimeFinish(v) then
        if theWorld and not IsNull(theWorld) and sceneBuildFinish == true and theWorld.GetWorldBuildingByPoint then
          local city = theWorld:GetWorldBuildingByPoint(buildData.pointId)
          if city ~= nil then
            city:ChangeToBox()
          end
        end
      elseif v:IsConstructing() and self.timeFinishFlag[v.occupyUuid] == nil and self:IsQueueTimeFinish(v) then
        self.timeFinishFlag[v.occupyUuid] = true
        if not IsNull(theWorld) and sceneBuildFinish == true then
          if buildData ~= nil and buildData.destroyStartTime <= 0 then
            local city = theWorld:GetBuildingByPoint(buildData.pointId)
            if city ~= nil then
              city:ChangeToBox()
            end
          end
          EventManager:GetInstance():Broadcast(EventId.Build_Time_End, v.occupyUuid)
          EventManager:GetInstance():Broadcast(EventId.GF_building_upgrade_time_over, buildData)
        end
      end
    end
  end
end

function BuildQueueManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.EffectNumChange, self.updateEffectCallback)
  EventManager:GetInstance():AddListener(EventId.BuildUpgradeFinish, self.onBuildFinish_action)
  EventManager:GetInstance():AddListener(EventId.UPDATE_BUILD_DATA, self.onBuildUpdate_action)
  EventManager:GetInstance():AddListener(EventId.Build_Time_End, self.onBuildFinish_action)
  EventManager:GetInstance():AddListener(EventId.BuildFixStart, self.onBuildFixUpgradeStart_action)
  EventManager:GetInstance():AddListener(EventId.BuildFixFinish, self.onBuildFixUpgradeFinish_action)
end

function BuildQueueManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.EffectNumChange, self.updateEffectCallback)
  EventManager:GetInstance():RemoveListener(EventId.BuildUpgradeFinish, self.onBuildFinish_action)
  EventManager:GetInstance():RemoveListener(EventId.UPDATE_BUILD_DATA, self.onBuildFinish_action)
  EventManager:GetInstance():RemoveListener(EventId.Build_Time_End, self.onBuildFinish_action)
  EventManager:GetInstance():RemoveListener(EventId.BuildFixStart, self.onBuildFixUpgradeStart_action)
  EventManager:GetInstance():RemoveListener(EventId.BuildFixFinish, self.onBuildFixUpgradeFinish_action)
end

function BuildQueueManager:GetQueueByUuid(uuid)
  local data = self.allQueueList[uuid]
  return data
end

function BuildQueueManager:GetQueueByIndex(index)
end

function BuildQueueManager:CheckHasContract()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  return curTime < self.specialQEndts
end

function BuildQueueManager:CheckMainUICanShow()
  return DataCenter.BuildManager:HasBuilding(BuildingTypes.LW_BUILD_WORKER_HOUSE) ~= nil
end

function BuildQueueManager:GetContractEndTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.specialQEndts then
    return self.specialQEndts
  end
  return 0
end

function BuildQueueManager:CheckNeedShowFirstContract()
  local data = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(BuildingTypes.LW_BUILD_WORKER_HOUSE)
  if data ~= nil then
    return data.level == 0 and data.updateTime == 0, data.uuid
  end
  return false
end

function BuildQueueManager:FirstContract()
  local need, bUuid = DataCenter.BuildQueueManager:CheckNeedShowFirstContract()
  BuildQueueGuide:FirstContract(need, false)
  if need then
    DataCenter.BuildManager:UpgradeBuilding(bUuid)
  end
end

function BuildQueueManager:GetUnlockPacks()
  local rechargeId = GiftPackageData.GetRechargeIdListByType(WelfareTagType.BuildQueueWeekCard)[1]
  local packs = {}
  if rechargeId then
    packs = GiftPackageData.GetAllAvailablePackageByRechargeId(rechargeId, false)
    if 1 < table.count(packs) then
      Logger.Info("Error: Multiple Recharge Packs for BuildQueue ", WelfareTagType.BuildQueueWeekCard)
    end
  end
  return packs
end

function BuildQueueManager:IsOrderQueueOwned(order)
  for _, v in pairs(self.allQueueList) do
    if v.order == order then
      return v:IsOwned()
    end
  end
  return false
end

function BuildQueueManager:IsAllPreQueueUnlock(order)
  local result = true
  local unlockOrder = -1
  for i = order - 1, 1, -1 do
    if not self:IsOrderQueueOwned(i) then
      result = false
      unlockOrder = i
      break
    end
  end
  return result, unlockOrder
end

function BuildQueueManager:HasNotExpireRentQueue()
  local result = false
  local id = 0
  for uuid, queueData in pairs(self.unlockedQueueList) do
    if queueData and queueData:IsRentQueue() and not queueData:IsExpired() then
      result = true
      id = queueData.id
      break
    end
  end
  return result, id
end

function BuildQueueManager:HasLockAndNotRentQueue(order)
  local hasLockAndNotRentQueue = false
  local orderResult = 0
  for i = order - 1, 1, -1 do
    for _, v in pairs(self.allQueueList) do
      if v.order == i and not v:IsRentQueue() and not v:IsUnlocked() then
        hasLockAndNotRentQueue = true
        orderResult = v.order
      end
    end
  end
  return hasLockAndNotRentQueue, orderResult
end

function BuildQueueManager:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function BuildQueueManager:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(0.5, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function BuildQueueManager:GetCanBuyQueue()
  if self:IsViewInUnlimitedMode() then
    return nil
  else
    local queues = {}
    for _, v in pairs(self.allQueueList) do
      if v:IsOwned() == false then
        table.insert(queues, v)
      end
    end
    if 0 < #queues then
      table.sort(queues, function(a, b)
        return a.order < b.order
      end)
      return queues[1].id
    else
      return nil
    end
  end
  return nil
end

function BuildQueueManager:GetFreeQueueIndex(isSeason)
  if isSeason then
    for _, v in pairs(self.allQueueList) do
      if v:CanUse() and DataCenter.BuildQueueTemplateManager:IsSeasonRobotByIndex(v.order) then
        return v.order
      end
    end
  end
  for _, v in pairs(self.allQueueList) do
    if v:CanUse() and not DataCenter.BuildQueueTemplateManager:IsSeasonRobotByIndex(v.order) then
      return v.order
    end
  end
  return 0
end

function BuildQueueManager:IsAnyQueueFree()
  local result = false
  for _, v in pairs(self.allQueueList) do
    if v and v:IsFreeQueue() then
      result = true
      break
    end
  end
  return result
end

function BuildQueueManager:GetMinRemainTimeQueue()
  local minTime = math.maxinteger
  local queue
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for _, v in pairs(self.allQueueList) do
    if v and not v:IsFreeQueue() then
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v.occupyUuid)
      local remainTime = buildData.updateTime - curTime
      if minTime > remainTime then
        minTime = remainTime
        queue = v
      end
    end
  end
  if queue then
    return queue
  end
end

return BuildQueueManager
