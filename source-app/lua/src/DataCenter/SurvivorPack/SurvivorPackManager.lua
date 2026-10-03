local SurvivorPackManager = BaseClass("SurvivorPackManager")

function SurvivorPackManager:__init()
  self.actData = {}
  self.receiveIdArr = {}
  self.receiveFreeArr = {}
  self.receivePayArr = {}
  self.receiveScoreArr = {}
  self.reward = {}
  self.bar_reward = {}
  self.list_group = ""
  self.score_item = ""
  self.actOpenDay = 1
  self.curDaySurvivorListIdArr = {}
  self.fakeVisitorDataArr = {}
  self.giftBubbleClickFuncDic = {}
end

function SurvivorPackManager:__delete()
  self.actData = nil
  self.receiveIdArr = nil
  self.receiveFreeArr = nil
  self.receivePayArr = nil
  self.receiveScoreArr = nil
  self.reward = nil
  self.bar_reward = nil
  self.list_group = nil
  self.score_item = nil
  self.actOpenDay = nil
  self.curDaySurvivorListIdArr = nil
  if self.fakeVisitorDataArr ~= nil then
    pcall(function()
      self:DeleteAllGiftFakeVisitors()
    end)
  end
  self.fakeVisitorDataArr = nil
  self.giftBubbleClickFuncDic = nil
  self:RemoveListener()
end

function SurvivorPackManager:RefreshTalentHallWorkerUpBubble()
  if DataCenter.BuildBubbleManager ~= nil and DataCenter.BuildBubbleManager.CheckShowByBubbleType ~= nil then
    DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.LWWorkerUp)
  end
end

function SurvivorPackManager:AddListeners()
  self:RemoveListener()
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnEnterCity, self.RefreshGiftVisitorsData, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.LOAD_COMPLETE, self.RefreshGiftVisitorsData, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnPassDay, self.RefreshGiftVisitorsData, self)
end

function SurvivorPackManager:RemoveListener()
  EventManager:GetInstance():RemoveListener2(EventId.OnEnterCity, self.RefreshGiftVisitorsData, self)
  EventManager:GetInstance():RemoveListener2(EventId.LOAD_COMPLETE, self.RefreshGiftVisitorsData, self)
  EventManager:GetInstance():RemoveListener2(EventId.OnPassDay, self.RefreshGiftVisitorsData, self)
end

function SurvivorPackManager:OnInitMessage(message)
  if message.activitySurvivorVisitor then
    self.receiveIdArr = message.activitySurvivorVisitor.receiveIdArr or {}
    self.receiveFreeArr = message.activitySurvivorVisitor.receiveFreeArr or {}
    self.receivePayArr = message.activitySurvivorVisitor.receivePayArr or {}
    self.receiveScoreArr = message.activitySurvivorVisitor.receiveScoreArr or {}
  end
end

function SurvivorPackManager:RefreshGiftVisitorsData()
  self:RefreshGiftVisitors()
  self:RefreshTalentHallWorkerUpBubble()
end

function SurvivorPackManager:ParseActivityInfo(actData)
  self.actData = actData
  self.bar_reward = {}
  self.list_group = ""
  self.score_item = ""
  local survivorCfgId = actData and (actData.tableInfoType or actData.subType)
  if survivorCfgId ~= nil then
    local survivorCfg = DataCenter.ActivitySurvivorTemplateManager:GetTemplate(survivorCfgId)
    if survivorCfg then
      self.bar_reward = self:ParseBarReward(survivorCfg.bar_reward)
      self.list_group = survivorCfg.list_group or ""
      self.score_item = survivorCfg.score_item or ""
    end
  end
  local startTime = actData.startTime
  self.actOpenDay = 1
  local startMs = tonumber(startTime)
  if startMs ~= nil then
    local nowMs = UITimeManager:GetInstance():GetServerTime()
    local startZero = UITimeManager:GetInstance():GetZeroTime(startMs)
    local nowZero = UITimeManager:GetInstance():GetZeroTime(nowMs)
    local dayDiff = math.floor((nowZero - startZero) / 86400000)
    self.actOpenDay = math.max(1, dayDiff + 1)
  end
  self:BuildCurDaySurvivorListIdArr()
  self:RefreshGiftVisitors()
  self:RefreshTalentHallWorkerUpBubble()
  self:AddListeners()
end

function SurvivorPackManager:BuildCurDaySurvivorListIdArr()
  self.curDaySurvivorListIdArr = self.curDaySurvivorListIdArr or {}
  self.curDaySurvivorListIdArr = {}
  local dayKey = self.actOpenDay ~= nil and tostring(self.actOpenDay) or ""
  local groupKey = self.list_group ~= nil and tostring(self.list_group) or ""
  if dayKey == "" then
    return self.curDaySurvivorListIdArr
  end
  local receivedSet = {}
  if self.receiveIdArr ~= nil then
    for _, rid in ipairs(self.receiveIdArr) do
      local k = rid ~= nil and tostring(rid) or ""
      if k ~= "" then
        receivedSet[k] = true
      end
    end
  end
  local curDayNum = tonumber(dayKey)
  DataCenter.ActivitySurvivorListTemplateManager:ForEachTemplate(function(survivorListId, tpl)
    local cfgDayNum = tonumber(tpl.day or "")
    if survivorListId == nil or cfgDayNum == nil or curDayNum == nil then
      return
    end
    if cfgDayNum > curDayNum or tostring(tpl.group or "") ~= groupKey then
      return
    end
    local idKey = tostring(survivorListId)
    if not receivedSet[idKey] then
      table.insert(self.curDaySurvivorListIdArr, survivorListId)
    end
  end)
  table.sort(self.curDaySurvivorListIdArr, function(a, b)
    return (tonumber(a) or 0) < (tonumber(b) or 0)
  end)
  return self.curDaySurvivorListIdArr
end

function SurvivorPackManager:RefreshCurDaySurvivorListIdArr()
  if self.actData == nil then
    return self.curDaySurvivorListIdArr
  end
  local startTime = self.actData.startTime
  local startMs = tonumber(startTime)
  if startMs ~= nil then
    local nowMs = UITimeManager:GetInstance():GetServerTime()
    local startZero = UITimeManager:GetInstance():GetZeroTime(startMs)
    local nowZero = UITimeManager:GetInstance():GetZeroTime(nowMs)
    local dayDiff = math.floor((nowZero - startZero) / 86400000)
    self.actOpenDay = math.max(1, dayDiff + 1)
  end
  return self:BuildCurDaySurvivorListIdArr()
end

function SurvivorPackManager:ParseBarReward(barReward)
  if string.IsNullOrEmpty(barReward) then
    return {}
  end
  local entries = {}
  local segments = string.split(barReward, "|") or {}
  for _, seg in pairs(segments) do
    if seg ~= nil and seg ~= "" then
      local lr = string.split(seg, ";") or {}
      local score = tonumber(lr[1]) or 0
      local rewardId = tonumber(lr[2])
      if rewardId == nil then
        rewardId = 0
      end
      table.insert(entries, {score = score, rewardId = rewardId})
    end
  end
  table.sort(entries, function(a, b)
    return (a.score or 0) < (b.score or 0)
  end)
  return entries
end

function SurvivorPackManager:OnRecInfo(message)
  self:ParseInfo(message)
end

function SurvivorPackManager:OnRecReward(message)
  self:ParseInfo(message)
  if message.reward then
    self.reward = message.reward
  end
  if message ~= nil and message.reward ~= nil then
    DataCenter.RewardManager:AddRewards(message.reward)
    DataCenter.RewardManager:ShowCommonReward(message)
  end
end

function SurvivorPackManager:ParseInfo(message)
  if message.receiveIdArr then
    self.receiveIdArr = message.receiveIdArr
  end
  if message.receiveFreeArr then
    self.receiveFreeArr = message.receiveFreeArr
  end
  if message.receivePayArr then
    self.receivePayArr = message.receivePayArr
  end
  if message.receiveScoreArr then
    self.receiveScoreArr = message.receiveScoreArr
  end
  EventManager:GetInstance():Broadcast(EventId.SurvivorPackInfoMsg)
  self:RefreshTalentHallWorkerUpBubble()
end

function SurvivorPackManager:IsFreeRewardReceivedById(id)
  if id == nil or self.receiveFreeArr == nil then
    return false
  end
  local key = tostring(id)
  for _, v in ipairs(self.receiveFreeArr) do
    if tostring(v) == key then
      return true
    end
  end
  return false
end

function SurvivorPackManager:IsPayRewardReceivedById(id)
  if id == nil or self.receivePayArr == nil then
    return false
  end
  local key = tostring(id)
  for _, v in ipairs(self.receivePayArr) do
    if tostring(v) == key then
      return true
    end
  end
  return false
end

function SurvivorPackManager:HasCanReceiveFreeOrProgressReward()
  local idArr = self.receiveIdArr or {}
  for _, survivorListId in ipairs(idArr) do
    if not self:IsFreeRewardReceivedById(survivorListId) then
      return true
    end
  end
  local scoreItemId = self.score_item or ""
  local itemCount = 0
  if not string.IsNullOrEmpty(scoreItemId) and DataCenter and DataCenter.ItemData and DataCenter.ItemData.GetItemById then
    local itemInfo = DataCenter.ItemData:GetItemById(scoreItemId)
    if itemInfo ~= nil and itemInfo.count ~= nil then
      itemCount = tonumber(itemInfo.count) or 0
    end
  end
  local barReward = self.bar_reward or {}
  if #barReward <= 0 then
    return false
  end
  local receivedScoreArr = self.receiveScoreArr or {}
  local receivedSet = {}
  for _, v in ipairs(receivedScoreArr) do
    local idx = tonumber(v)
    if idx ~= nil then
      receivedSet[idx] = true
    end
  end
  for stageIndex1, data in ipairs(barReward) do
    local stageIndex0 = stageIndex1 - 1
    local score = tonumber(data and data.score) or 0
    if itemCount >= score and not receivedSet[stageIndex0] then
      return true
    end
  end
  return false
end

function SurvivorPackManager:GetVisitorDataById(survivorListId)
  if survivorListId == nil then
    return nil
  end
  local groupKey = self.list_group or ""
  local survivorTemplate = DataCenter.ActivitySurvivorListTemplateManager:GetTemplate(survivorListId, groupKey)
  if survivorTemplate == nil or string.IsNullOrEmpty(survivorTemplate.visitor_id) then
    return nil
  end
  local visitorEventId = tonumber(survivorTemplate.visitor_id)
  if visitorEventId == nil then
    return nil
  end
  local cityLine = LocalController:instance():getLine(TableName.City_Visitor, visitorEventId)
  if cityLine == nil then
    return nil
  end
  local appearanceId = cityLine.model_path or 0
  local quality = tonumber(survivorTemplate.quality) or 1
  local lastNameKey = survivorTemplate.job or ""
  local firstNameKey = cityLine.first_name or ""
  local nameKey = cityLine.name or ""
  if string.IsNullOrEmpty(lastNameKey) then
    lastNameKey = nameKey
  end
  if string.IsNullOrEmpty(firstNameKey) then
    firstNameKey = nameKey
  end
  local workerTemplate = {
    appearance = appearanceId,
    quality = quality,
    last_name = lastNameKey,
    first_name = firstNameKey
  }
  return {
    survivorListId = tonumber(survivorListId) or survivorListId,
    visitorId = visitorEventId,
    workerTemplate = workerTemplate
  }
end

function SurvivorPackManager:RefreshGiftVisitors()
  if self.actData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endMs = tonumber(self.actData.endTime)
  local startMs = tonumber(self.actData.startTime)
  local actEnded = endMs ~= nil and curTime >= endMs
  local actNotStarted = startMs ~= nil and curTime < startMs
  if actEnded or actNotStarted then
    if #(self.fakeVisitorDataArr or {}) > 0 then
      self:DeleteAllGiftFakeVisitors()
    end
    return
  end
  self:RefreshCurDaySurvivorListIdArr()
  local idArr = self.curDaySurvivorListIdArr or {}
  self:DeleteAllGiftFakeVisitors(true)
  self.fakeVisitorDataArr = {}
  for i = 1, #idArr do
    local survivorListId = idArr[i]
    local survivorVisitorData = self:GetVisitorDataById(survivorListId)
    local visitorEventId = survivorVisitorData and survivorVisitorData.visitorId or nil
    if visitorEventId ~= nil then
      local actId = tonumber(self.actData and self.actData.activityId)
      if actId ~= nil then
        local survivorListIdNum = tonumber(survivorListId)
        if survivorListIdNum == nil then
          survivorListIdNum = tonumber(i) or 0
        end
        local fakeUid = 900000000000 + actId * 1000000 + survivorListIdNum
        local fakeVisitorData = DataCenter.CityVisitorManager:CreateOneFakeVisitorDataByEventId(visitorEventId, fakeUid)
        if fakeVisitorData ~= nil then
          do
            local survivorListIdCapture = survivorListId
            self.giftBubbleClickFuncDic[fakeUid] = function()
              UIManager:GetInstance():OpenWindow(UIWindowNames.UISurvivorPackPopup, {
                anim = true,
                UIMainAnim = UIMainAnimType.AllHide
              }, fakeUid, survivorListIdCapture)
            end
            table.insert(self.fakeVisitorDataArr, fakeVisitorData)
            DataCenter.CityVisitorManager:AddVisitor(fakeVisitorData, true, i)
          end
        end
      end
    end
  end
  if SceneUtils.GetIsInCity() then
    DataCenter.CityVisitorManager:ReGenVisitors()
  end
end

function SurvivorPackManager:DeleteAllGiftFakeVisitors(skipReGenInCity)
  local inCity = SceneUtils.GetIsInCity()
  local uidTypeToDelete = {}
  for _, v in ipairs(self.fakeVisitorDataArr or {}) do
    if v ~= nil and v.uid ~= nil and v.type ~= nil then
      uidTypeToDelete[v.uid] = v.type
    end
  end
  local queueVisitors = DataCenter.CityVisitorManager:GetQueueAllVisitorData(2) or {}
  for i = 1, #queueVisitors do
    local visitorWrap = queueVisitors[i]
    local visitorData = visitorWrap and visitorWrap.data or nil
    if visitorData ~= nil and visitorData.uid ~= nil and visitorData.type == VisitorType.SURVIVOR_PACK_GiFT then
      uidTypeToDelete[visitorData.uid] = visitorData.type
    end
  end
  for uid, visitorType in pairs(uidTypeToDelete) do
    pcall(function()
      DataCenter.CityVisitorManager:DeleteVisitor(uid, visitorType)
    end)
  end
  for uid, _ in pairs(self.giftBubbleClickFuncDic or {}) do
    self.giftBubbleClickFuncDic[uid] = nil
  end
  self.fakeVisitorDataArr = {}
  if inCity and not skipReGenInCity then
    DataCenter.CityVisitorManager:ReGenVisitors()
  end
  local hasVisitor = DataCenter.CityVisitorManager:GetFristVisitorData() ~= nil
  EventManager:GetInstance():Broadcast(EventId.RefreshVisitorBtnState, hasVisitor)
end

function SurvivorPackManager:GetShowSurvivorList()
  local showSurvivorList = {}
  local tplDic = {}
  local groupKey = self.list_group ~= nil and tostring(self.list_group) or ""
  for _, v in ipairs(self.receiveIdArr or {}) do
    if not self:IsFreeRewardReceivedById(v) or not self:IsPayRewardReceivedById(v) then
      local tpl = DataCenter.ActivitySurvivorListTemplateManager:GetTemplate(v, groupKey)
      if tpl ~= nil then
        local idKey = tostring(v)
        tplDic[idKey] = tpl
        table.insert(showSurvivorList, v)
      end
    end
  end
  table.sort(showSurvivorList, function(a, b)
    local tplA = tplDic[tostring(a)]
    local tplB = tplDic[tostring(b)]
    if tplA == nil or tplB == nil then
      return (tonumber(a) or 0) < (tonumber(b) or 0)
    end
    local hasFreeA = not string.IsNullOrEmpty(tplA.free)
    local hasFreeB = not string.IsNullOrEmpty(tplB.free)
    local freeAvailA = not (not hasFreeA or self:IsFreeRewardReceivedById(a)) and 1 or 0
    local freeAvailB = not (not hasFreeB or self:IsFreeRewardReceivedById(b)) and 1 or 0
    if freeAvailA ~= freeAvailB then
      return freeAvailA > freeAvailB
    end
    local qA = tonumber(tplA and tplA.quality or 0) or 0
    local qB = tonumber(tplB and tplB.quality or 0) or 0
    if qA ~= qB then
      return qA > qB
    end
    local freeDoneA = self:IsFreeRewardReceivedById(a) and 1 or 0
    local freeDoneB = self:IsFreeRewardReceivedById(b) and 1 or 0
    if freeDoneA ~= freeDoneB then
      return freeDoneA < freeDoneB
    end
    return (tonumber(a) or 0) < (tonumber(b) or 0)
  end)
  return showSurvivorList
end

function SurvivorPackManager:OnGiftPopupClosed(fakeUid)
  if fakeUid == nil then
    return
  end
  local actId = tonumber(self.actData and self.actData.activityId)
  if actId == nil then
    return
  end
  local fakeUidNum = tonumber(fakeUid) or 0
  local survivorListIdNum = fakeUidNum - 900000000000 - actId * 1000000
  survivorListIdNum = tonumber(survivorListIdNum)
  if survivorListIdNum == nil or survivorListIdNum <= 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SurvivorVisitorReceiveBubble, actId, survivorListIdNum)
  if DataCenter and DataCenter.CityVisitorManager and DataCenter.CityVisitorManager.PlayVisitorFinishAni then
    DataCenter.CityVisitorManager:PlayVisitorFinishAni(fakeUid, VisitorType.SURVIVOR_PACK_GiFT, 1)
  elseif DataCenter and DataCenter.CityVisitorManager and DataCenter.CityVisitorManager.DeleteVisitor then
    DataCenter.CityVisitorManager:DeleteVisitor(fakeUid, VisitorType.SURVIVOR_PACK_GiFT)
  end
end

function SurvivorPackManager:TryInvokeGiftBubbleClick(clickKey)
  if clickKey == nil or self.giftBubbleClickFuncDic == nil then
    return false
  end
  local fn = self.giftBubbleClickFuncDic[clickKey]
  if fn ~= nil then
    fn()
    return true
  end
  return false
end

function SurvivorPackManager:IsActOpen()
  local actData = self.actData
  if actData == nil or actData.startTime == nil or actData.endTime == nil then
    return false
  end
  local nowTime = UITimeManager:GetInstance():GetServerTime()
  return nowTime >= actData.startTime and nowTime < actData.endTime
end

function SurvivorPackManager:GetTalentHallFreeBubbleIconPath()
  if not self:IsActOpen() then
    return nil, nil
  end
  local showList = self:GetShowSurvivorList() or {}
  local firstId = showList[1]
  if firstId == nil then
    return nil, nil
  end
  local freeReceived = self:IsFreeRewardReceivedById(firstId)
  if not freeReceived then
    local groupKey = self.list_group or ""
    local survivorTpl = DataCenter.ActivitySurvivorListTemplateManager:GetTemplate(firstId, groupKey)
    local workerId = survivorTpl and tonumber(survivorTpl.worker_id) or nil
    if workerId ~= nil and 0 < workerId then
      local workerLine = LocalController:instance():getLine(TableName.LW_Worker, workerId)
      local appearanceId = workerLine and tonumber(workerLine.appearance) or nil
      if appearanceId ~= nil and 0 < appearanceId then
        local iconPath = WorkerUtil.GetWorkerIconPath(appearanceId, nil)
        if not string.IsNullOrEmpty(iconPath) then
          return iconPath, 1
        end
      end
    end
  end
  return nil, nil
end

function SurvivorPackManager:GetTalentHallPayBubbleIconPath()
  if not self:IsActOpen() then
    return nil, nil
  end
  local showList = self:GetShowSurvivorList() or {}
  local firstId = showList[1]
  if firstId == nil then
    return nil, nil
  end
  local freeReceived = self:IsFreeRewardReceivedById(firstId)
  local payReceived = self:IsPayRewardReceivedById(firstId)
  if freeReceived and not payReceived then
    return string.format(LoadPath.UIBuildBubble, "wxy_xingcunzhe_libao_qipao"), 3
  end
  return nil, nil
end

return SurvivorPackManager
