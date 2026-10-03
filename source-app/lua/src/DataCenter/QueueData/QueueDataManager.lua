local QueueDataManager = BaseClass("QueueDataManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.queueDic = {}
  self.farmUuidDict = {}
  self.pastureUuidDict = {}
  self.timeFinishFlag = {}
  self.heroFreeTimeDict = {}
  self.timer = nil
  
  function self.timer_action(temp)
    self:CheckAllQueueTimeFinish()
  end
  
  self:AddTimer()
end

local function __delete(self)
  self.queueDic = nil
  self.timeFinishFlag = nil
  self.heroFreeTimeDict = nil
  self.timer_action = nil
  self:DeleteTimer()
end

local function Startup()
end

local function InitQueueDataList(self, message)
  if message.queue_new ~= nil then
    self.queueDic = {}
    table.walk(message.queue_new, function(k, v)
      self:UpdateQueueData(v)
    end)
  end
end

local PastureQueueType2EffectId = {}
PastureQueueType2EffectId[NewQueueType.OstrichBarn] = EffectDefine.ADD_OSTRICH_NUM
PastureQueueType2EffectId[NewQueueType.CattleBarn] = EffectDefine.ADD_COW_NUM
PastureQueueType2EffectId[NewQueueType.SandWormBarn] = EffectDefine.ADD_PIG_NUM
local EffectId2BuildId = {}
EffectId2BuildId[EffectDefine.ADD_OSTRICH_NUM] = BuildingTypes.APS_BUILD_PASTURE_OSTRICH
EffectId2BuildId[EffectDefine.ADD_COW_NUM] = BuildingTypes.APS_BUILD_PASTURE_CATTLE
EffectId2BuildId[EffectDefine.ADD_PIG_NUM] = BuildingTypes.APS_BUILD_PASTURE_SANDWORM
local EffectId2PastureQueueType = {}
EffectId2PastureQueueType[EffectDefine.ADD_OSTRICH_NUM] = NewQueueType.OstrichBarn
EffectId2PastureQueueType[EffectDefine.ADD_COW_NUM] = NewQueueType.CattleBarn
EffectId2PastureQueueType[EffectDefine.ADD_PIG_NUM] = NewQueueType.SandWormBarn

local function GetQueueMaxNumByPastureQueueType(self, type)
  if PastureQueueType2EffectId[type] ~= nil then
    return LuaEntry.Effect:GetGameEffect(PastureQueueType2EffectId[type])
  end
  return 0
end

local function DoWhenPastureEffectChange(self, effectId)
  local maxNum = LuaEntry.Effect:GetGameEffect(effectId)
  local buildId = EffectId2BuildId[effectId]
  local queueType = EffectId2PastureQueueType[effectId]
  if buildId ~= nil and queueType ~= nil then
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
    if buildData == nil then
      return
    end
    local pastureQueues = self.pastureUuidDict[buildData.uuid]
    if pastureQueues == nil and 0 < maxNum then
      pastureQueues = {}
      self.pastureUuidDict[buildData.uuid] = pastureQueues
    end
    if pastureQueues ~= nil then
      local total = table.count(pastureQueues)
      if maxNum < total then
        local deleteQueue = {}
        table.walk(pastureQueues, function(k, v)
          if v.qid > maxNum then
            table.insert(deleteQueue, k)
          end
        end)
        for _, v in ipairs(deleteQueue) do
          pastureQueues[v] = nil
          EventManager:GetInstance():Broadcast(EventId.DeletePastureQueue, v)
        end
        EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, buildData.uuid)
      elseif maxNum > total then
        table.walk(self.queueDic, function(k, queueData)
          if queueData.type == queueType and queueData.funcUuid ~= nil and queueData.funcUuid ~= 0 and queueData.qid <= maxNum then
            if self.pastureUuidDict[queueData.funcUuid] == nil then
              self.pastureUuidDict[queueData.funcUuid] = {}
            end
            self.pastureUuidDict[queueData.funcUuid][k] = queueData
          end
        end)
        EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, buildData.uuid)
      end
    end
  end
end

local function UpdateQueueData(self, message)
  if message == nil then
    return
  end
  if message.uuid == nil then
    return
  end
  local uuid = message.uuid
  if self.queueDic[uuid] == nil then
    local queue = QueueInfo.New()
    self.queueDic[uuid] = queue
  end
  self.queueDic[uuid]:ParseData(message)
  local queueData = self:GetQueueByUuid(uuid)
  if queueData ~= nil then
    if queueData.type == NewQueueType.Field then
      self.farmUuidDict[uuid] = queueData
    elseif queueData.type == NewQueueType.OstrichBarn or queueData.type == NewQueueType.CattleBarn or queueData.type == NewQueueType.SandWormBarn then
      local max = self:GetQueueMaxNumByPastureQueueType(queueData.type)
      if queueData.funcUuid ~= nil and queueData.funcUuid ~= 0 and max >= queueData.qid then
        if self.pastureUuidDict[queueData.funcUuid] == nil then
          self.pastureUuidDict[queueData.funcUuid] = {}
        end
        self.pastureUuidDict[queueData.funcUuid][uuid] = queueData
      end
    end
    if queueData:GetQueueState() == NewQueueState.Finish and self.heroFreeTimeDict[queueData.uuid] then
      self.heroFreeTimeDict[queueData.uuid] = nil
    end
    EventManager:GetInstance():Broadcast(EventId.UPDATE_QUEUE_DATA, queueData)
  end
end

local function ResetQueue(self, uuid, paraState)
  if self.queueDic[uuid] ~= nil then
    local queueType = self.queueDic[uuid].type
    if queueType == NewQueueType.Field then
      if self.farmUuidDict[uuid] ~= nil then
        self.farmUuidDict[uuid]:ResetQueue(paraState)
      end
    elseif queueType == NewQueueType.OstrichBarn or queueType == NewQueueType.CattleBarn or queueType == NewQueueType.SandWormBarn then
      for k, v in pairs(self.pastureUuidDict) do
        if v[uuid] ~= nil then
          v[uuid]:ResetQueue(paraState)
          break
        end
      end
    end
    self.queueDic[uuid]:ResetQueue(paraState)
    self.timeFinishFlag[uuid] = nil
    self.heroFreeTimeDict[uuid] = nil
  end
end

local function GetQueueByUuid(self, uuid)
  return self.queueDic[uuid]
end

local function GetQueueByType(self, qType)
  if not self.queueDic then
    return nil
  end
  for k, v in pairs(self.queueDic) do
    if v.type == qType then
      return v
    end
  end
  return nil
end

local function DeleteQueueByUuid(self, uuid)
  self.queueDic[uuid] = nil
  self.farmUuidDict[uuid] = nil
  for _, v in pairs(self.pastureUuidDict) do
    v[uuid] = nil
  end
  self.timeFinishFlag[uuid] = nil
  self.heroFreeTimeDict[uuid] = nil
end

local function GetQueueByScienceId(self, scienceId)
  for k, v in pairs(self.queueDic) do
    if v.itemId == scienceId then
      return v
    end
  end
  return nil
end

local function GetBuildUuidInFinishQueueForPasture(self)
  local bUuidList = {}
  for k, queueDataList in pairs(self.pastureUuidDict) do
    for uuid, queueData in pairs(queueDataList) do
      if queueData ~= nil and queueData:GetParaState() == QueueProductState.PASTURE_MATURE and queueData:GetQueueState() == NewQueueState.Finish then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(queueData.funcUuid)
        if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp then
          table.insert(bUuidList, queueData.funcUuid)
        end
      end
    end
  end
  return bUuidList
end

local function GetBuildUuidInFreeQueueByType(self, qType)
  local bUuidList = {}
  if qType == NewQueueType.Field then
    for k, queueData in pairs(self.farmUuidDict) do
      if queueData ~= nil and queueData:GetQueueState() == NewQueueState.Free then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(queueData.funcUuid)
        if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp then
          table.insert(bUuidList, queueData.funcUuid)
        end
      end
    end
  else
    for k, v in pairs(self.queueDic) do
      if v.type == qType and v:GetQueueState() == NewQueueState.Free then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v.funcUuid)
        if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp then
          table.insert(bUuidList, v.funcUuid)
        end
      end
    end
  end
  return bUuidList
end

local function GetBuildUuidInFinishQueueByType(self, qType)
  local bUuidList = {}
  if qType == NewQueueType.Field then
    for k, queueData in pairs(self.farmUuidDict) do
      if queueData ~= nil and queueData:GetQueueState() == NewQueueState.Finish then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(queueData.funcUuid)
        if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp then
          table.insert(bUuidList, queueData.funcUuid)
        end
      end
    end
  elseif qType == NewQueueType.OstrichBarn or qType == NewQueueType.CattleBarn or qType == NewQueueType.SandWormBarn then
    for k, queueDataList in pairs(self.pastureUuidDict) do
      for uuid, queueData in pairs(queueDataList) do
        if queueData ~= nil and queueData.type == qType and queueData:GetQueueState() == NewQueueState.Finish then
          local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(queueData.funcUuid)
          if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp then
            table.insert(bUuidList, queueData.funcUuid)
          end
        end
      end
    end
  else
    for k, v in pairs(self.queueDic) do
      if v.type == qType and v:GetQueueState() == NewQueueState.Finish then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v.funcUuid)
        if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp then
          table.insert(bUuidList, v.funcUuid)
        end
      end
    end
  end
  return bUuidList
end

local function GetQueueByBuildUuidForFarm(self, bUuid)
  for k, queueData in pairs(self.farmUuidDict) do
    if queueData ~= nil and queueData.funcUuid == bUuid then
      return queueData
    end
  end
  return nil
end

function QueueDataManager:GetFirstUuidByType(type)
  for k, v in pairs(self.queueDic) do
    if v.funcUuid ~= nil and v.type == type then
      return v.funcUuid
    end
  end
  return nil
end

function QueueDataManager:GetQueueDatasByType(type)
  local list = {}
  for k, v in pairs(self.queueDic) do
    if v.funcUuid ~= nil and v.type == type then
      table.insert(list, v)
    end
  end
  return list
end

local function GetQueueByBuildUuidForScience(self, bUuid)
  for k, v in pairs(self.queueDic) do
    if v.funcUuid == bUuid and v.type == NewQueueType.Science then
      return v
    end
  end
  return nil
end

local function GetQueueByBuildItemIdForScience(self, bUuid)
  for k, v in pairs(self.queueDic) do
    if v.type == NewQueueType.Science and v.funcUuid then
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v.funcUuid)
      if buildData ~= nil and buildData.itemId == bUuid then
        return v
      end
    end
  end
  return nil
end

local function GetIsQueueFreeForScienceId(self)
  for k, v in pairs(self.queueDic) do
    if v.type == NewQueueType.Science and v:GetQueueState() == NewQueueState.Free then
      return v
    end
  end
  return nil
end

local function GetQueueListByBuildUuidForPasture(self, bUuid)
  local list = self.pastureUuidDict[bUuid]
  if list == nil then
    list = {}
  end
  return list
end

local function GetCanPlantForPastureByBuildUuid(self, bUuid)
  local canPlant = false
  local dic = self.pastureUuidDict[bUuid]
  if dic ~= nil then
    for k, queueData in pairs(dic) do
      if queueData ~= nil and queueData.funcUuid == bUuid and (queueData.type == NewQueueType.OstrichBarn or queueData.type == NewQueueType.CattleBarn or queueData.type == NewQueueType.SandWormBarn) and queueData:GetParaState() == QueueProductState.DEFAULT and queueData:GetQueueState() == NewQueueState.Free then
        canPlant = true
        return canPlant
      end
    end
  end
  return canPlant
end

local function ResetAllQueue(self)
  table.walk(self.queueDic, function(k, v)
    v:ResetQueue()
  end)
  self.timeFinishFlag = {}
  self.heroFreeTimeDict = {}
end

local function QueueFinishHandle(self, message, paraState)
  if message.errorCode == nil then
    local uuid = message.uuid
    if uuid ~= nil then
      local queue = self:GetQueueByUuid(uuid)
      if queue ~= nil then
        if queue.type == NewQueueType.DragonHospital then
          UIUtil.ShowTipsId(130127)
          self:ResetQueue(uuid, paraState)
          EventManager:GetInstance():Broadcast(EventId.HospitalFinish)
        elseif queue.type == NewQueueType.Hospital then
          local healCount = DataCenter.HospitalManager:GetHealCount()
          if healCount <= 0 then
            self:ResetQueue(uuid, paraState)
          end
          EventManager:GetInstance():Broadcast(EventId.HospitalFinish)
        elseif queue.type == NewQueueType.Science then
          local template = DataCenter.ScienceManager:GetScienceTemplate(tonumber(queue.itemId))
          if template ~= nil then
            DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Science_Finish, false)
            local alhelpData = DataCenter.AllianceHelpDataManager:GetSelfAllianceHelp(queue.uuid)
            UIUtil.ShowTips(Localization:GetString(GameDialogDefine.RESEARCHING_FINISH, Localization:GetString(template.name)))
          end
          self:ResetQueue(uuid, paraState)
          if message.robot ~= nil then
            DataCenter.BuildQueueManager:UpdateQueueData(message.robot)
          end
          EventManager:GetInstance():Broadcast(EventId.OnScienceQueueFinish, uuid)
        elseif queue.type == NewQueueType.FootSoldier or queue.type == NewQueueType.CarSoldier or queue.type == NewQueueType.BowSoldier then
          local armyId = ""
          local count = 0
          local nameDes = "130058"
          local tempList = string.split(queue.itemId, ";")
          if tempList ~= nil and 3 < #tempList then
            nameDes = "360105"
            armyId = tempList[3]
            count = tempList[4]
          elseif tempList ~= nil and 1 < #tempList then
            nameDes = "130058"
            armyId = tempList[1]
            count = tempList[2]
          end
          if queue.type == NewQueueType.FootSoldier then
            DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Train_Soldiers, false)
          elseif queue.type == NewQueueType.CarSoldier then
            DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Train_Tank, false)
          elseif queue.type == NewQueueType.BowSoldier then
            DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Train_Aircraft, false)
          end
          local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
          if template ~= nil then
            local str = Localization:GetString("130058", Localization:GetString(template.name) .. " x" .. count)
            local max = DataCenter.ArmyManager:GetArmyNumMax()
            local total = DataCenter.ArmyManager:GetTotalArmyNum() - math.ceil(count)
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UINoticeEquipTips) then
              TimerManager:GetInstance():DelayInvoke(function()
                UIManager:GetInstance():OpenWindow(UIWindowNames.UISoliderGetTip, {anim = true}, str, count, total, max, max, template.arm)
              end, 3)
            else
              UIManager:GetInstance():OpenWindow(UIWindowNames.UISoliderGetTip, {anim = true}, str, count, total, max, max, template.arm)
            end
          end
          self:ResetQueue(uuid, paraState)
          EventManager:GetInstance():Broadcast(EventId.TrainingArmyFinish, queue.type)
          EventManager:GetInstance():Broadcast(EventId.GF_building_training_finished, message)
        elseif queue.type == NewQueueType.Field then
          local buildUuid = queue.funcUuid
          self:ResetQueue(uuid, paraState)
          local str = tostring(buildUuid) .. ";" .. tostring(queue.itemId)
          EventManager:GetInstance():Broadcast(EventId.ShowCapacity, str)
        elseif queue.type == NewQueueType.OstrichBarn or queue.type == NewQueueType.CattleBarn or queue.type == NewQueueType.SandWormBarn then
          local buildUuid = queue.funcUuid
          self:ResetQueue(uuid, paraState)
        elseif queue.type == NewQueueType.RebirthHospital then
          local healCount = DataCenter.RebirthHospitalManager:GetRebirthQueueFinishSoldierCount()
          if healCount <= 0 then
            self:ResetQueue(uuid, paraState)
          end
          EventManager:GetInstance():Broadcast(EventId.RebirthHospitalFinish)
        elseif queue.type == NewQueueType.T11Break then
          self:ResetQueue(uuid, paraState)
          EventManager:GetInstance():Broadcast(EventId.T11ResearchQueueFinish)
        end
      end
    end
  else
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
  end
end

local function QueueFinishBatchHandle(self, message)
  DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.PlantFarm, nil)
  if message.errorCode == nil then
    local paraState = message.paraState
    local msgDic = {}
    local allPastureUid = {}
    if message.queueList ~= nil then
      table.walk(message.queueList, function(k, v)
        if v.uuid ~= nil then
          local queue = self:GetQueueByUuid(v.uuid)
          local functionTemplate = DataCenter.FarmingDataManager:GetFramingTemplate(queue.itemId)
          if functionTemplate ~= nil then
            local itemId = ""
            local count = 0
            if queue:GetParaState() == QueueProductState.PASTURE_MATURE then
              table.walk(functionTemplate.second_get_goods, function(m, n)
                itemId = m
                count = n
              end)
              table.insert(allPastureUid, v.uuid)
            else
              table.walk(functionTemplate.get_goods, function(m, n)
                itemId = m
                count = n
              end)
            end
            local resourceItemData = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
            if resourceItemData ~= nil then
              if msgDic[resourceItemData.name] == nil then
                msgDic[resourceItemData.name] = 0
              end
              msgDic[resourceItemData.name] = msgDic[resourceItemData.name] + count
            end
          end
        end
        self:QueueFinishHandle(v, paraState)
      end)
      EventManager:GetInstance():Broadcast(EventId.GatherResourceItemFinish, allPastureUid)
    end
    EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
  else
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
    EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
  end
end

local function QueueCcsMNewHandle(self, message)
  if message.errorCode == nil then
    if message.queue ~= nil then
      local queueType
      local dic = message.queue
      local uuid = dic.uuid
      if dic ~= nil and dic.type ~= nil then
        queueType = dic.type
      end
      local arrays = dic.itemCostArr
      if arrays ~= nil then
        for k, v in pairs(arrays) do
          DataCenter.ItemData:UpdateOneItem(v)
        end
      end
      if dic.remainGold ~= nil then
        LuaEntry.Player.gold = dic.remainGold
        EventManager:GetInstance():Broadcast(EventId.UpdateGold)
      end
      DataCenter.QueueDataManager:UpdateQueueData(dic)
      local queueData = self:GetQueueByUuid(uuid)
      if queueData ~= nil then
        if queueType == NewQueueType.Field then
          queueData:SetQueueFinishForFarm()
          EventManager:GetInstance():Broadcast(EventId.AddSpeedSuccess, queueData.funcUuid)
        elseif queueType == NewQueueType.OstrichBarn or queueType == NewQueueType.CattleBarn or queueType == NewQueueType.SandWormBarn then
          queueData:SetQueueFinishForFarm()
          EventManager:GetInstance():Broadcast(EventId.AddSpeedSuccess, uuid)
        end
      end
      EventManager:GetInstance():Broadcast(EventId.AddSpeedSuccess, queueType)
    end
  else
    local temp = message.errorCode
    if temp ~= SeverErrorCode then
      if temp == "E100173" then
        UIUtil.ShowTipsId(170008)
      else
        UIUtil.ShowTips(Localization:GetString(message.errorCode))
      end
    end
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function CheckAllQueueTimeFinish(self)
  for k, v in pairs(self.queueDic) do
    if self.timeFinishFlag[k] == nil then
      if self:IsQueueTimeFinish(v) then
        self.timeFinishFlag[k] = true
        local queueType = v.type
        if queueType == NewQueueType.Science then
          local bUuid = tonumber(v.funcUuid)
          if bUuid ~= nil then
            local queue = DataCenter.BuildQueueManager:GetQueueDataByBuildUuid(bUuid, false, true)
            if queue ~= nil then
              DataCenter.BuildQueueManager:ResetQueue(queue.uuid)
            end
            if self.heroFreeTimeDict[k] then
              self.heroFreeTimeDict[k] = nil
            end
          end
        end
        EventManager:GetInstance():Broadcast(EventId.QUEUE_TIME_END, v.type)
      elseif v.type == NewQueueType.Science and (self.heroFreeTimeDict[k] == nil or not self.heroFreeTimeDict[k][2]) then
        local bUuid = tonumber(v.funcUuid)
        if bUuid ~= nil and v.endTime ~= 0 then
          local freeTime = DataCenter.HeroDataManager:GetFreeAddTimeHero(EffectDefine.RESEARCH_TIME_REDUCE)
          local effectTime = LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE)
          if freeTime or 0 < effectTime then
            local curTime = UITimeManager:GetInstance():GetServerTime()
            if v.endTime > 0 and v.endTime ~= LongMaxValue and v.endTime - curTime <= effectTime * 1000 then
              self.heroFreeTimeDict[k] = {}
              self.heroFreeTimeDict[k][1] = bUuid
              self.heroFreeTimeDict[k][2] = false
              self.heroFreeTimeDict[k][3] = RobotState.SCIENCE
              self.heroFreeTimeDict[k][4] = k
              local queue = DataCenter.BuildQueueManager:GetQueueDataByBuildUuid(bUuid, false, true)
              if queue then
                self.heroFreeTimeDict[k][5] = queue.robotId
              end
              EventManager:GetInstance():Broadcast(EventId.QueueHeroFreeTime, {uuid = bUuid, type = 2})
            end
          end
        end
      end
    end
  end
end

local function IsQueueTimeFinish(self, queue)
  return queue ~= nil and queue:GetQueueState() == NewQueueState.Finish
end

local function AllianceHelpAddSpeed(self, uuid, endTime, startT)
  if self.queueDic[uuid] ~= nil then
    if startT then
      self.queueDic[uuid].startTime = startT
    end
    self.queueDic[uuid].endTime = endTime
  end
end

local function OnAllianceCallHelp(self, uuid)
  if self.queueDic[uuid] ~= nil then
    self.queueDic[uuid].isHelped = 1
  end
end

local function GetAllQueue(self)
  return self.queueDic
end

local function GetFarmQueueLatestTime(self)
  local time = 0
  for k, queueData in pairs(self.farmUuidDict) do
    if queueData ~= nil and queueData:GetQueueState() == NewQueueState.Work and queueData.type == NewQueueType.Field and time < queueData.endTime then
      time = queueData.endTime
    end
  end
  local result = (time - UITimeManager:GetInstance():GetServerTime()) / 1000
  result = math.max(result, 0)
  return result
end

local function GetPastureQueueLatestTime(self)
  local time = 0
  for k, queueDataList in pairs(self.pastureUuidDict) do
    for uuid, queueData in pairs(queueDataList) do
      if queueData ~= nil and queueData:GetQueueState() == NewQueueState.Work and (queueData.type == NewQueueType.OstrichBarn or queueData.type == NewQueueType.CattleBarn or queueData.type == NewQueueType.SandWormBarn) and time < queueData.endTime then
        time = queueData.endTime
      end
    end
  end
  local result = (time - UITimeManager:GetInstance():GetServerTime()) / 1000
  result = math.max(result, 0)
  return result
end

local function FreeSpeedQueueHandle(self, message)
  if message.errorCode == nil then
    if message.queueArr ~= nil then
      for k, v in pairs(message.queueArr) do
        self:UpdateQueueData(v)
        local uuid = v.uuid
        local queueType = v.type
        local queueData = self:GetQueueByUuid(uuid)
        if queueData ~= nil then
          if queueType == NewQueueType.Field then
            EventManager:GetInstance():Broadcast(EventId.AddSpeedSuccess, queueData.funcUuid)
          elseif queueType == NewQueueType.OstrichBarn or queueType == NewQueueType.CattleBarn or queueType == NewQueueType.SandWormBarn then
            EventManager:GetInstance():Broadcast(EventId.AddSpeedSuccess, uuid)
          end
        end
        EventManager:GetInstance():Broadcast(EventId.AddSpeedSuccess, queueType)
      end
    end
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  end
end

local function GetAllQueueByType(self, qType)
  local result = {}
  if qType == NewQueueType.Field then
    return self.farmUuidDict
  elseif qType == NewQueueType.OstrichBarn or qType == NewQueueType.CattleBarn or qType == NewQueueType.SandWormBarn then
    for k, queueDataList in pairs(self.pastureUuidDict) do
      for uuid, queueData in pairs(queueDataList) do
        if queueData ~= nil and queueData.type == qType then
          table.insert(result, queueData)
        end
      end
    end
  else
    for k, v in pairs(self.queueDic) do
      if v.type == qType then
        table.insert(result, v)
      end
    end
  end
  return result
end

local function GetPastureAllFreeBuilding(self)
  local tmp = {}
  for k, queueDataList in pairs(self.pastureUuidDict) do
    for uuid, queueData in pairs(queueDataList) do
      if queueData ~= nil and (queueData.type == NewQueueType.OstrichBarn or queueData.type == NewQueueType.CattleBarn or queueData.type == NewQueueType.SandWormBarn) then
        local state = queueData:GetQueueState()
        local paramState = queueData:GetParaState()
        if paramState == QueueProductState.DEFAULT and state == NewQueueState.Free then
        elseif paramState == QueueProductState.DEFAULT and state == NewQueueState.Finish or paramState == QueueProductState.PASTURE_MATURE and state == NewQueueState.Free or paramState == QueueProductState.DEFAULT and state == NewQueueState.Work then
          tmp[queueData.funcUuid] = true
          break
        end
      end
    end
  end
  local result = {}
  table.walk(tmp, function(k, v)
    if v == true then
      table.insert(result, k)
    end
  end)
  return result
end

local function SetFinishFlag(self, uuid, value)
  self.timeFinishFlag[uuid] = value
end

local function SetCanUseHeroFreeTime(self, uuid)
  for i, v in pairs(self.heroFreeTimeDict) do
    if v[1] == uuid then
      v[2] = true
    end
  end
end

local function GetCanUseHeroFreeTime(self, uuid)
  for i, v in pairs(self.heroFreeTimeDict) do
    if v[1] == uuid then
      return v
    end
  end
  return nil
end

QueueDataManager.__init = __init
QueueDataManager.__delete = __delete
QueueDataManager.Startup = Startup
QueueDataManager.InitQueueDataList = InitQueueDataList
QueueDataManager.UpdateQueueData = UpdateQueueData
QueueDataManager.ResetQueue = ResetQueue
QueueDataManager.GetQueueByUuid = GetQueueByUuid
QueueDataManager.GetQueueByType = GetQueueByType
QueueDataManager.DeleteQueueByUuid = DeleteQueueByUuid
QueueDataManager.ResetAllQueue = ResetAllQueue
QueueDataManager.QueueFinishHandle = QueueFinishHandle
QueueDataManager.QueueCcsMNewHandle = QueueCcsMNewHandle
QueueDataManager.DeleteTimer = DeleteTimer
QueueDataManager.AddTimer = AddTimer
QueueDataManager.CheckAllQueueTimeFinish = CheckAllQueueTimeFinish
QueueDataManager.IsQueueTimeFinish = IsQueueTimeFinish
QueueDataManager.AllianceHelpAddSpeed = AllianceHelpAddSpeed
QueueDataManager.OnAllianceCallHelp = OnAllianceCallHelp
QueueDataManager.GetQueueByBuildUuidForFarm = GetQueueByBuildUuidForFarm
QueueDataManager.QueueFinishBatchHandle = QueueFinishBatchHandle
QueueDataManager.GetBuildUuidInFreeQueueByType = GetBuildUuidInFreeQueueByType
QueueDataManager.GetBuildUuidInFinishQueueByType = GetBuildUuidInFinishQueueByType
QueueDataManager.GetQueueListByBuildUuidForPasture = GetQueueListByBuildUuidForPasture
QueueDataManager.GetCanPlantForPastureByBuildUuid = GetCanPlantForPastureByBuildUuid
QueueDataManager.GetBuildUuidInFinishQueueForPasture = GetBuildUuidInFinishQueueForPasture
QueueDataManager.GetAllQueue = GetAllQueue
QueueDataManager.GetFarmQueueLatestTime = GetFarmQueueLatestTime
QueueDataManager.GetPastureQueueLatestTime = GetPastureQueueLatestTime
QueueDataManager.FreeSpeedQueueHandle = FreeSpeedQueueHandle
QueueDataManager.GetAllQueueByType = GetAllQueueByType
QueueDataManager.GetPastureAllFreeBuilding = GetPastureAllFreeBuilding
QueueDataManager.GetQueueByBuildUuidForScience = GetQueueByBuildUuidForScience
QueueDataManager.GetQueueByBuildItemIdForScience = GetQueueByBuildItemIdForScience
QueueDataManager.GetQueueByScienceId = GetQueueByScienceId
QueueDataManager.GetIsQueueFreeForScienceId = GetIsQueueFreeForScienceId
QueueDataManager.SetFinishFlag = SetFinishFlag
QueueDataManager.SetCanUseHeroFreeTime = SetCanUseHeroFreeTime
QueueDataManager.GetCanUseHeroFreeTime = GetCanUseHeroFreeTime
QueueDataManager.GetQueueMaxNumByPastureQueueType = GetQueueMaxNumByPastureQueueType
QueueDataManager.DoWhenPastureEffectChange = DoWhenPastureEffectChange
return QueueDataManager
