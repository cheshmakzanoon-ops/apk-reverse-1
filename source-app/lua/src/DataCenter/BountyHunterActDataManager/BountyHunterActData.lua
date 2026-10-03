local BountyHunterActData = BaseClass("BountyHunterActData")
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")
local BountyHunterSceneData = require("DataCenter.BountyHunterActDataManager.BountyHunterSceneData")
local ActivityFreeRewardData = require("DataCenter.ActivityFreeRewardData.ActivityFreeRewardData")
local BountyHunterMonsterData = require("DataCenter.BountyHunterActDataManager.BountyHunterMonsterData")
local LWUICommonExchangeShopData_BountyHunter = require("UI/ActivityCommon/LWUICommonExchangeShop/LWUICommonExchangeShop_BountyHunter/LWUICommonExchangeShopData_BountyHunter")
local ActivityHunterShopTemplate = require("DataCenter/BountyHunterActDataManager/ActivityHunterShopTemplate")
local ActivityHunterDropshowTemplate = require("DataCenter/BountyHunterActDataManager/ActivityHunterDropshowTemplate")
local Const = require("UI/UIActivityCenterTable/Component/ActBountyHunter/BountyHunterConstant")

local function __init(self)
  self.activityId = -1
  self.activityTmpData = nil
  self.hunterActTmpData = nil
  self.score = 0
  self.refreshCount = 0
  self.lastShopTime = 0
  self.lastFreeTime = 0
  self.phaseRewardList = {}
  self.claimedPhaseReward = {}
  self.shopInfo = {}
  self.stashRewardArr = {}
  self.historyRewardArr = {}
  self.batLogArr = {}
  self.hadReceiveRewardScoreDic = {}
  self.eventShopDataDict = {}
  self.eventBossDataDict = {}
  self.sceneData = BountyHunterSceneData.New()
  self.activityFreeRewardData = ActivityFreeRewardData.New()
  self.todayShoot = 0
  self.nextRefreshTime = 0
  self.isFullSynedLogData = false
end

local function __delete(self)
  self.activityId = nil
  self.activityTmpData = nil
  self.hunterActTmpData = nil
  self.score = nil
  self.refreshCount = nil
  self.lastShopTime = nil
  self.lastFreeTime = nil
  self.claimedPhaseReward = nil
  self.shopInfo = nil
  self.stashRewardArr = nil
  self.historyRewardArr = nil
  self.batLogArr = nil
  self.hadReceiveRewardScoreDic = nil
  self.eventShopDataDict = nil
  self.eventBossDataDict = {}
  self.sceneData = nil
  self.activityFreeRewardData = nil
  self.todayShoot = nil
  self.nextRefreshTime = nil
  self.isFullSynedLogData = nil
end

function BountyHunterActData:UpdateData(activityId, msg)
  self.activityId = activityId
  self.sceneData:Init(activityId)
  self.activityTmpData = LocalController:instance():getLine(TableName.Activity, activityId)
  if not self.activityTmpData then
    Logger.ErrorLog("activity data is null : " .. activityId)
    return
  end
  if not self.activityTmpData.tableInfo or not self.activityTmpData.tableInfoType then
    Logger.ErrorLog("activity tableInfoType is null : " .. activityId)
    return
  end
  self.hunterActTmpData = LocalController:instance():getLine(self.activityTmpData.tableInfo, toInt(self.activityTmpData.tableInfoType))
  if not self.hunterActTmpData then
    Logger.ErrorLog("activity hunterActTmpData is null : " .. activityId)
    return
  end
  self.hunterActTmpParaData = LocalController:instance():getLine(TableName.Bounty_Hunter_Para, toInt(self.hunterActTmpData.para_group))
  if msg.commonKey then
    local commonInfo = msg.commonKey
    self.score = commonInfo.score
    self.refreshCount = commonInfo.refreshCount
    self.lastShopTime = commonInfo.lastShopTime
    self.lastFreeTime = commonInfo.lastFreeTime
    self.claimedPhaseReward = commonInfo.claimedPhaseReward
    self:UpdateTodayConsume(commonInfo)
    self:UpdateTotalConsume(commonInfo)
    local phaseRewardInfo = commonInfo.phaseReward or {}
    for _, v in pairs(phaseRewardInfo) do
      self:UpdateHadReceiveRewardInfo(v)
    end
    self:UpdateNextBossCount(commonInfo)
    self:UpdateShopEventTimes(commonInfo.todayEventShop)
  end
  if msg.shopKey then
    self.shopInfo = msg.shopKey
  end
  if msg.stageKey then
    local stashRewardData = msg.stageKey.stashReward
    self:UpdateStashReward(stashRewardData)
    local historyRewardData = msg.stageKey.historyReward
    self:UpdateHistoryReward(historyRewardData)
    local triggerEvent = msg.stageKey.triggerEvent
    self:UpdateSingleEventBossData(triggerEvent)
  end
  if msg.eventShopKey then
    local eventShopData = msg.eventShopKey
    for i, v in pairs(eventShopData) do
      self:UpdateSingleEventShopData(v)
    end
  end
  self:ParsePhaseReward()
  self:CheckRecoveryCD()
  local stageInfo = msg.stageKey
  if stageInfo and self.sceneData then
    self.sceneData:UpdateStageData(stageInfo)
  end
  self:UpdateActivityFreeRewardData()
end

function BountyHunterActData:ParsePhaseReward()
  if not self.hunterActTmpData then
    return
  end
  if not self.hunterActTmpData.score_reward or not self.hunterActTmpData.score_reward_show then
    return
  end
  local phaseRewardScoreList = {}
  local phaseRewardScoreStr = string.split(self.hunterActTmpData.score_reward, "|")
  for _, v in ipairs(phaseRewardScoreStr) do
    local scoreInfo = string.split(v, ";")
    if #scoreInfo == 2 then
      table.insert(phaseRewardScoreList, toInt(scoreInfo[1]))
    end
  end
  self.phaseRewardList = {}
  local phaseRewardInfo = self.hunterActTmpData.score_reward_show
  local rewardStrArr = string.split(phaseRewardInfo, "|")
  for _, v in ipairs(rewardStrArr) do
    local info = string.split(v, ";")
    if #info == 3 then
      local rewardInfo = {}
      rewardInfo.type = toInt(info[1])
      rewardInfo.itemId = toInt(info[2])
      rewardInfo.num = toInt(info[3])
      table.insert(self.phaseRewardList, rewardInfo)
    end
  end
  for i = 1, #phaseRewardScoreList do
    local data = self.phaseRewardList[i]
    local needScore = phaseRewardScoreList[i]
    if data then
      data.needScore = needScore
    end
  end
end

function BountyHunterActData:GetGiftPackId()
  if not self.hunterActTmpData then
    return nil
  end
  local exchangeId = self.hunterActTmpData.box_exchange
  if not exchangeId or exchangeId <= 0 then
    Logger.LogError("bounty hunter exchangeId is null!")
    return nil
  end
  return exchangeId
end

function BountyHunterActData:GetActRed()
  local res = 0
  res = res + self:GetExchangeShopRed()
  res = res + self:GetRewardProgressRed()
  res = res + self:GetStashRewardRed()
  res = res + self:GetGiftPackageRed()
  return res
end

function BountyHunterActData:CheckRecoveryCD()
  if not self.hunterActTmpData then
    return
  end
  if self.refreshCount >= self.hunterActTmpData.max_refreshtime then
    return
  end
  local nextDayZeroTime = UITimeManager:GetInstance():GetTomorrowZero()
  self.nextRecoveryTime = nextDayZeroTime
  if self.recoveryTimer then
    self.recoveryTimer:Stop()
    self.recoveryTimer = nil
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local recoverCD = (self.nextRecoveryTime - now) / 1000
  if recoverCD <= 0 then
    return
  end
  self.recoveryTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.refreshCount < self.hunterActTmpData.max_refreshtime then
      self.refreshCount = self.refreshCount + (self.hunterActTmpData.time_recoverytimes or 1)
      EventManager:GetInstance():Broadcast(EventId.BountyHunterRefreshCountChange, self.activityId)
    end
  end, recoverCD)
end

function BountyHunterActData:UpdateDailyRewardData(message)
  if message.lastFreeTime ~= nil then
    self.lastFreeTime = message.lastFreeTime
  end
  self:UpdateActivityFreeRewardData()
end

function BountyHunterActData:UpdateActivityFreeRewardData()
  self.activityFreeRewardData.activityId = self.activityId
  if self.hunterActTmpData and self.hunterActTmpData.box_reward > 0 then
    self.activityFreeRewardData.freeReward = RewardUtil.GetRewardItem(self.hunterActTmpData.box_reward)
  end
  self.activityFreeRewardData.lastReceiveFreeTime = self.lastFreeTime
  self.activityFreeRewardData.nextRefreshTime = self.nextRefreshTime
  self.rewardPackGroupId = self:GetGiftPackId()
end

function BountyHunterActData:GetGiftPackageRed()
  return 0
end

function BountyHunterActData:IsFreeGiftPackageCanBuy()
  local giftId = self:GetGiftPackId()
  if giftId then
    local giftPack = GiftPackManager.GetPacksByGroupId(giftId, false, false)
    for _, v in pairs(giftPack) do
      local buyType = v:GetBuyType()
      if buyType == GiftPackageBuyType.Free then
        return true
      end
    end
  end
  return false
end

function BountyHunterActData:UpdateStashReward(stashData)
  if not stashData then
    return
  end
  self.stashRewardArr = stashData
  EventManager:GetInstance():Broadcast(EventId.BountyHunterStashRewardDataUpdate)
  if self:GetStashRewardRed() > 0 then
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

function BountyHunterActData:ClearStashReward()
  self:UpdateStashReward({})
end

function BountyHunterActData:UpdateHistoryReward(historyRewardData)
  if not historyRewardData then
    return
  end
  self.historyRewardArr = historyRewardData
end

function BountyHunterActData:GetCurStashRewardData()
  return self.stashRewardArr
end

function BountyHunterActData:GetStashRewardRed()
  local curStashReward = self:GetCurStashRewardData()
  if curStashReward and 0 < #curStashReward then
    return 1
  else
    return 0
  end
end

function BountyHunterActData:GetHistoryClaimRewardData()
  return self.historyRewardArr
end

function BountyHunterActData:UpdateRefreshData(refreshCount)
  if not refreshCount then
    return
  end
  self.refreshCount = refreshCount
end

function BountyHunterActData:UpdateEventData(data)
  if data.supportEvent then
    local supportData = data.supportEvent
    for _, v in ipairs(supportData) do
      self:UpdateScore(v.score)
    end
  end
  if data.shopEvent then
    self:UpdateSingleEventShopData(data.shopEvent)
    EventManager:GetInstance():Broadcast(EventId.BountyHunterShopEventUpdate)
    local shopEventTimes = data.shopEvent.todayEventShop
    self:UpdateShopEventTimes(shopEventTimes)
  end
  if self.sceneData then
    self.sceneData:UpdateMonsterDataWhenTriggerEvent(data)
  end
end

function BountyHunterActData:UpdateScore(value)
  if not value or value < 0 then
    return
  end
  self.score = value
  EventManager:GetInstance():Broadcast(EventId.BountyHunterScoreUpdate, self.activityId)
end

function BountyHunterActData:UpdateHadReceiveRewardInfo(targetScore)
  if not self.hadReceiveRewardScoreDic then
    return
  end
  self.hadReceiveRewardScoreDic[targetScore] = true
end

function BountyHunterActData:UpdateBatLogData(data)
  self.batLogArr = data
  if self.batLogArr then
    table.sort(self.batLogArr, function(a, b)
      return a.timestamp > b.timestamp
    end)
  end
  self.isFullSynedLogData = true
end

function BountyHunterActData:GetBatLogShowCountLimit()
  if self.hunterActTmpParaData and self.hunterActTmpParaData.log_limit then
    return self.hunterActTmpParaData.log_limit
  end
  return -1
end

function BountyHunterActData:AppendBatLogData(data)
  table.insert(self.batLogArr, 1, data)
end

function BountyHunterActData:RemoveBatLogData(uuid)
  if self.batLogArr then
    for i, v in ipairs(self.batLogArr) do
      if v.uuid == uuid then
        table.remove(self.batLogArr, i)
        break
      end
    end
  end
end

function BountyHunterActData:GetBatLogData()
  return self.batLogArr
end

function BountyHunterActData:GetExchangeShopDataList()
  local res = {}
  if self.hunterActTmpData and self.hunterActTmpData.shopid then
    local shopGroupId = checknumber(self.hunterActTmpData.shopid)
    if 0 < shopGroupId then
      LocalController:instance():visitTable(TableName.ACTIVITY_HUNTER_SHOP, function(id, lineData)
        if lineData ~= nil and checknumber(lineData.group) == shopGroupId then
          local template = ActivityHunterShopTemplate.New()
          template:UpdateData(lineData)
          local data = LWUICommonExchangeShopData_BountyHunter.New(template, self.activityId)
          table.insert(res, data)
        end
      end)
    end
  end
  table.sort(res, function(a, b)
    local isSoldA = a:IsSoldOut()
    local isSoldB = b:IsSoldOut()
    if isSoldA ~= isSoldB then
      return not isSoldA
    end
    return a:GetDisplayOrder() > b:GetDisplayOrder()
  end)
  return res
end

function BountyHunterActData:IsExchangeShopRedOn()
  return false
end

function BountyHunterActData:SetExchangeShopRedOn(value)
  if value then
    UIUtil.ShowTipsId("activity_99051desc_2")
  end
  CS.GameEntry.Setting:SetBool("activity_bounty_hunter_exchange_red_" .. LuaEntry.Player.uid, value)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function BountyHunterActData:GetExchangeShopBoughtTimes(shopId)
  shopId = tonumber(shopId)
  if self.shopInfo then
    for i, v in pairs(self.shopInfo) do
      if v.id == shopId then
        return v.buyTimes
      end
    end
  end
end

function BountyHunterActData:UpdateExchangeShopBuyTimes(shopId, buyTimes)
  if not self.shopInfo then
    self.shopInfo = {}
  end
  for i, v in pairs(self.shopInfo) do
    if v.id == shopId then
      v.buyTimes = buyTimes
      return
    end
  end
  table.insert(self.shopInfo, {id = shopId, buyTimes = buyTimes})
end

function BountyHunterActData:GetExchangeShopRed()
  return 0
end

function BountyHunterActData:GetEndTime()
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if actData ~= nil then
    return actData:GetShowEndTime()
  end
  return 0
end

function BountyHunterActData:GetStartTime()
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if actData ~= nil then
    return actData:GetShowStartTime()
  end
  return 0
end

function BountyHunterActData:GetActivityType()
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if actData ~= nil then
    return actData.type
  end
  return 0
end

function BountyHunterActData:GetActivityId()
  return self.activityId
end

function BountyHunterActData:TriggerGuide(callback)
  if self.activityTmpData and not string.IsNullOrEmpty(self.activityTmpData.plot) then
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
      plotGroupId = tonumber(self.activityTmpData.plot),
      hideMainUI = true,
      callback = callback
    })
  end
end

function BountyHunterActData:BreakGuide()
  if self.activityTmpData and not string.IsNullOrEmpty(self.activityTmpData.plot) then
    EventManager:GetInstance():Broadcast(EventId.PlotGroupDone, tonumber(self.activityTmpData.plot))
    Logger.LogInfo("BountyHunterActData:BreakGuide : " .. (tonumber(self.activityTmpData.plot) or 0))
  end
end

function BountyHunterActData:GetAllDropShowTemplates()
  local res = {}
  if self.hunterActTmpData and self.hunterActTmpData.dropshow then
    LocalController:instance():visitTable(TableName.ACTIVITY_HUNTER_DROPSHOW, function(id, lineData)
      if lineData and lineData.group_id == self.hunterActTmpData.dropshow then
        local template = ActivityHunterDropshowTemplate.New()
        template:UpdateData(lineData)
        table.insert(res, template)
      end
    end)
  end
  return res
end

function BountyHunterActData:GetTodayConsumeLeftTime()
  local curTime = self:GetTodayConsumeTime()
  if self.hunterActTmpData and self.hunterActTmpData.max_daily and self.hunterActTmpData.max_daily > 0 then
    return math.max(self.hunterActTmpData.max_daily - curTime, 0)
  end
  return -1
end

function BountyHunterActData:GetTotalConsumeTime()
  return self.totalShoot or 0
end

function BountyHunterActData:UpdateTotalConsume(data)
  if not data then
    return
  end
  if data.totalShoot then
    self.totalShoot = data.totalShoot
  end
end

function BountyHunterActData:GetTodayConsumeTime()
  local nowTime = UITimeManager:GetInstance():GetServerTime()
  if nowTime >= self.nextRefreshTime then
    return 0
  end
  return self.todayShoot
end

function BountyHunterActData:UpdateTodayConsume(data)
  if not data then
    return
  end
  if data.todayShoot then
    self.todayShoot = data.todayShoot
  end
  if data.nextRefreshTime then
    self.nextRefreshTime = data.nextRefreshTime
  end
  EventManager:GetInstance():Broadcast(EventId.BountyHunterTodayConsumeUpdate)
end

function BountyHunterActData:ClearEventBossDataDict()
  self.eventBossDataDict = {}
end

function BountyHunterActData:UpdateSingleEventBossData(data)
  if not self.eventBossDataDict or not data then
    return
  end
  for _, v in pairs(self.eventBossDataDict) do
    v.count = 0
  end
  for _, v in pairs(data) do
    local lineData = LocalController:instance():tryGetLine(TableName.Bounty_Hunter_Event, v)
    if lineData and lineData.event == BountyHunterEventType4Server.Boss then
      if not self.eventBossDataDict[v] then
        self.eventBossDataDict[v] = {id = v, count = 0}
      end
      self.eventBossDataDict[v].count = self.eventBossDataDict[v].count + 1
    end
  end
end

function BountyHunterActData:GetEventBossDataCount()
  local count = 0
  for k, v in pairs(self.eventBossDataDict) do
    count = v.count + count
  end
  return count
end

function BountyHunterActData:GetEarliestEventBossData()
  local _, bossData = next(self.eventBossDataDict)
  return bossData
end

function BountyHunterActData:ClearEventShopDataDict()
  self.eventShopDataDict = {}
end

function BountyHunterActData:UpdateSingleEventShopData(data)
  if not self.eventShopDataDict or not data then
    return
  end
  local uuid = data.uuid
  self.eventShopDataDict[uuid] = data
end

function BountyHunterActData:GetEarliestEventShopData()
  if not table.IsNullOrEmpty(self.eventShopDataDict) then
    local res
    local curTime = UITimeManager:GetInstance():GetServerTime()
    for i, v in pairs(self.eventShopDataDict) do
      if v.durationTime and curTime < v.durationTime and (res == nil or v.durationTime < res.durationTime) then
        res = v
      end
    end
    return res
  end
end

function BountyHunterActData:GetEventShopDataCount()
  local list = self:GetEventShopDataListInTimeOrder()
  return table.count(list)
end

function BountyHunterActData:GetEventShopDataListInTimeOrder()
  local res = {}
  if self.eventShopDataDict then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    for i, v in pairs(self.eventShopDataDict) do
      if v.durationTime and curTime < v.durationTime then
        table.insert(res, v)
      end
    end
  end
  table.sort(res, function(a, b)
    return a.durationTime < b.durationTime
  end)
  return res
end

function BountyHunterActData:GetEventShopDataByUuid(uuid)
  if self.eventShopDataDict then
    return self.eventShopDataDict[uuid]
  end
end

function BountyHunterActData:GetRefreshItemCount()
  if self.hunterActTmpData and self.hunterActTmpData.refresh_item then
    return DataCenter.ItemData:GetItemCount(self.hunterActTmpData.refresh_item)
  end
  return 0
end

function BountyHunterActData:GetRefreshItemName()
  if self.hunterActTmpData and self.hunterActTmpData.refresh_item then
    return DataCenter.ItemTemplateManager:GetName(self.hunterActTmpData.refresh_item)
  end
  return ""
end

function BountyHunterActData:GetRefreshItemIcon()
  if self.hunterActTmpData and self.hunterActTmpData.refresh_item then
    return DataCenter.ItemTemplateManager:GetIconPath(self.hunterActTmpData.refresh_item)
  end
  return ""
end

function BountyHunterActData:GetRewardProgressRed()
  local curScore = self.score or 0
  local rewardInfo = self.phaseRewardList
  if not rewardInfo then
    return 0
  end
  local res = 0
  for i = 1, #rewardInfo do
    local curRewardNeedScore = rewardInfo[i].needScore or 0
    if curScore >= curRewardNeedScore then
      local isReceived = self.hadReceiveRewardScoreDic and self.hadReceiveRewardScoreDic[curRewardNeedScore]
      if not isReceived then
        res = res + 1
      end
    end
  end
  return res
end

function BountyHunterActData:HasShownAttackMonsterDirectlyConfirm()
  local key = "activity_bounty_hunter_attack_directly_confirm_" .. tostring(self:GetActivityId()) .. tostring(self:GetEndTime())
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

function BountyHunterActData:SetHasShownAttackMonsterDirectlyConfirm()
  local key = "activity_bounty_hunter_attack_directly_confirm_" .. tostring(self:GetActivityId()) .. tostring(self:GetEndTime())
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
end

function BountyHunterActData:GetRefreshItemEverydayAddCount()
  if self.hunterActTmpData and self.hunterActTmpData.time_recoverytimes then
    return self.hunterActTmpData.time_recoverytimes
  end
  return 0
end

function BountyHunterActData:GetMainRewardShowData()
  if self.hunterActTmpParaData and self.hunterActTmpParaData.main_reward_show then
    local res = {}
    for i, v in ipairs(self.hunterActTmpParaData.main_reward_show) do
      local splitStr = string.split(v, ";")
      if #splitStr == 3 then
        local reward = {
          rewardType = tonumber(splitStr[1]),
          itemId = tonumber(splitStr[2]),
          count = tonumber(splitStr[3])
        }
        table.insert(res, reward)
      end
    end
    return res
  end
end

function BountyHunterActData:HasShownFirstGuideUI()
  local key = "activity_bounty_hunter_first_guide_ui_" .. tostring(self:GetActivityId()) .. tostring(self:GetEndTime())
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

function BountyHunterActData:SetHasShownFirstGuideUI()
  local key = "activity_bounty_hunter_first_guide_ui_" .. tostring(self:GetActivityId()) .. tostring(self:GetEndTime())
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
end

function BountyHunterActData:UpdateNextBossCount(data)
  if data and data.nextBossCount then
    self.nextBossCount = data.nextBossCount
  end
end

function BountyHunterActData:GetNextBossCount()
  return self.nextBossCount or 0
end

function BountyHunterActData:TryShowSecondConfirm(key, contentText, onConfirm)
  if not self:HasShownSecondConfirm(key) then
    local isOn = false
    UIUtil.ShowSecondMessage(nil, contentText, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      onConfirm()
      if isOn then
        self:SetHasShownSecondConfirm(key)
      end
    end, function(notIsOn)
      isOn = not notIsOn
    end, nil, nil, nil, Localization:GetString("activity_hunter_alert16"))
  else
    onConfirm()
  end
end

function BountyHunterActData:HasShownSecondConfirm(key)
  key = "activity_bounty_hunter_second_confirm_" .. key .. tostring(self:GetActivityId()) .. tostring(self:GetEndTime())
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

function BountyHunterActData:SetHasShownSecondConfirm(key)
  key = "activity_bounty_hunter_second_confirm_" .. key .. tostring(self:GetActivityId()) .. tostring(self:GetEndTime())
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
end

function BountyHunterActData:SetHasShownSecondConfirmState(key, state)
  key = "activity_bounty_hunter_second_confirm_" .. key .. tostring(self:GetActivityId()) .. tostring(self:GetEndTime())
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, state)
end

function BountyHunterActData:GetExchangeShopBuyTimesRefreshTime()
  if self.lastShopTime ~= nil and self.lastShopTime > 0 then
    return UITimeManager:GetInstance():GetTodayZeroServerTime(self.lastShopTime / 1000) * 1000 + 86400000
  end
  return 0
end

function BountyHunterActData:GetBountyHunterTmp()
  return self.hunterActTmpData
end

function BountyHunterActData:GetHunterActTmpParaData()
  return self.hunterActTmpParaData
end

function BountyHunterActData:UpdateShopEventTimes(shopEventTimes)
  self.shopEventTimes = shopEventTimes or 0
end

function BountyHunterActData:GetCurShopEventTimes()
  return self.shopEventTimes or 0
end

function BountyHunterActData:GetSkipBtnShowTime()
  if not (self.hunterActTmpParaData and self.hunterActTmpParaData.skip_guide_para) or #self.hunterActTmpParaData.skip_guide_para < 3 then
    return Const.SHOW_SKIP_BTN_TIME
  end
  return self.hunterActTmpParaData.skip_guide_para[1] / 1000
end

function BountyHunterActData:GetAutoSkipPlotTime()
  if not (self.hunterActTmpParaData and self.hunterActTmpParaData.skip_guide_para) or #self.hunterActTmpParaData.skip_guide_para < 3 then
    return Const.AUTO_BREAK_GUIDE_TIME
  end
  return self.hunterActTmpParaData.skip_guide_para[2] / 1000
end

function BountyHunterActData:GetAutoEnterSceneTime()
  if not (self.hunterActTmpParaData and self.hunterActTmpParaData.skip_guide_para) or #self.hunterActTmpParaData.skip_guide_para < 3 then
    return Const.AUTO_ENTER_SCENE
  end
  return self.hunterActTmpParaData.skip_guide_para[3] / 1000
end

function BountyHunterActData:GetSuperShootInfo()
  if not self.hunterActTmpData then
    return
  end
  if string.IsNullOrEmpty(self.hunterActTmpData.cost_extra) then
    return
  end
  local splitStr = string.split(self.hunterActTmpData.cost_extra, ";")
  if #splitStr ~= 3 then
    return
  end
  return {
    superShootMinNum = tonumber(splitStr[1]),
    goodsId = splitStr[2],
    costGoodsNum = tonumber(splitStr[3])
  }
end

function BountyHunterActData:CanSuperShoot()
  local info = self:GetSuperShootInfo()
  if info == nil then
    return false
  end
  local itemCount = self:GetSuperShootItemCount()
  return itemCount >= info.superShootMinNum
end

function BountyHunterActData:GetSuperShootItemCount()
  local info = self:GetSuperShootInfo()
  if info == nil then
    return 0
  end
  local itemCount = 0
  local item = DataCenter.ItemData:GetItemById(info.goodsId)
  if item ~= nil then
    itemCount = item.count or 0
  end
  return itemCount
end

function BountyHunterActData:GetRefreshItemUseMinNum()
  if not self.hunterActTmpData then
    return 1
  end
  return math.max(self.hunterActTmpData.cost_extra_low, 1)
end

function BountyHunterActData:IsActivityTheLastDay()
  local endTime = self:GetEndTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  return endTime - now < OneDayTime * 1000
end

function BountyHunterActData:GetCurActivityDayCount()
  local startTime = self:GetStartTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  return math.floor((now - startTime) / (OneDayTime * 1000))
end

function BountyHunterActData:CheckFinalDayShootCountEnough()
  if not self.hunterActTmpData then
    return false
  end
  if string.IsNullOrEmpty(self.hunterActTmpData.attack_alert) then
    return false
  end
  if not self:IsActivityTheLastDay() then
    return false
  end
  local tab = string.split(self.hunterActTmpData.attack_alert, ";")
  if #tab ~= 2 then
    return false
  end
  local targetGoodsId = tab[1]
  local minCount = tab[2]
  local count = self:GetSuperShootItemCount()
  local shopCount = self:GetShopCanBuyItemCount(targetGoodsId)
  local stashReward = self:GetCurStashRewardData()
  local stashRewardCount = 0
  if stashReward then
    for _, reward in pairs(stashReward) do
      if tostring(reward.value.id) == tostring(targetGoodsId) then
        stashRewardCount = reward.value.num + stashRewardCount
      end
    end
  end
  return count + shopCount + stashRewardCount < tonumber(minCount)
end

function BountyHunterActData:GetShopCanBuyItemCount(id)
  local count = 0
  local giftId = self:GetGiftPackId()
  if giftId then
    local giftPack = GiftPackManager.GetPacksByGroupId(giftId, false, false)
    for _, v in pairs(giftPack) do
      local rewards = v:getItems(true)
      for _, reward in pairs(rewards) do
        if tostring(reward.itemId) == tostring(id) then
          count = reward.count * (v:getBuyTimes() - v:getHasGetCount()) + count
        end
      end
      local freeRewards = v:getFreeAndGoldBuyReward()
      if freeRewards then
        for _, reward in pairs(freeRewards) do
          if tostring(reward.itemId) == tostring(id) then
            count = reward.count * (v:getBuyTimes() - v:getHasGetCount()) + count
          end
        end
      end
    end
  end
  return count
end

function BountyHunterActData:CheckShopTimesMax()
  local alreadyRefreshTimes = self:GetCurShopEventTimes()
  local maxRefreshTimes = 0
  local paramTmp = self:GetHunterActTmpParaData()
  if paramTmp and paramTmp.event_daily_maxnum then
    maxRefreshTimes = paramTmp.event_daily_maxnum[BountyHunterEventType4Server.Shop] or 0
  end
  return alreadyRefreshTimes >= maxRefreshTimes
end

BountyHunterActData.__init = __init
BountyHunterActData.__delete = __delete
return BountyHunterActData
