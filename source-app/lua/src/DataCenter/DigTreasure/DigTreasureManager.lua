local DigTreasureManager = BaseClass("DigTreasureManager", CEventable)
local DiggingMapData = require("DataCenter.DiggingGame.DiggingMapData")
local ActDispatchTreasureRewardItemTemplate = require("DataCenter.ActivityListData.ActDispatchTreasureRewardItemTemplate")
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

function DigTreasureManager:__init()
  self:RegisterEvent(EventId.RefreshItems, self.RefreshUseItemNum)
end

function DigTreasureManager:InitData(tData)
  self.nActivityId = tData.id
  self:RefreshUseItemNum()
end

function DigTreasureManager:RequestData()
  if self:IsActivityOpen() then
    SFSNetwork.SendMessage(MsgDefines.DigTreasureGameInfo)
  end
end

function DigTreasureManager:IsActivityOpen()
  local tDataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.DigTreasure.Type)
  if tDataList and tDataList[1] and DataCenter.ActivityListDataManager:CheckIsSend(tDataList[1]) then
    return true
  end
  return false
end

function DigTreasureManager:IsNewActivityOpen()
  local tData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.OFF_SEASON_Treasure_V2.Type)
  if tData and DataCenter.ActivityListDataManager:CheckIsSend(tData) then
    return true
  end
  return false
end

function DigTreasureManager:GetNewActivityData()
  local tData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.OFF_SEASON_Treasure_V2.Type)
  if tData and DataCenter.ActivityListDataManager:CheckIsSend(tData) then
    return tData
  end
  return nil
end

function DigTreasureManager:IsActPreviewOpen()
  local tDataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.DigTreasurePreview.Type)
  if tDataList and tDataList[1] and DataCenter.ActivityListDataManager:CheckIsSend(tDataList[1]) then
    return tDataList[1]
  end
  return nil
end

function DigTreasureManager:GetUseItemId()
  if not self.nUseItemId then
    self.nUseItemId = LuaEntry.DataConfig:TryGetNum("Treasure_map_hummer", "k1")
  end
  return self.nUseItemId
end

function DigTreasureManager:GetUseItemNum()
  local nId = self:GetUseItemId()
  local tItemInfo = DataCenter.ItemData:GetItemById(nId)
  if not tItemInfo then
    return 0
  end
  return tItemInfo.count
end

function DigTreasureManager:GetOpenBlockSingleCost()
  if not self.nOpenSingleCost then
    self.nOpenSingleCost = LuaEntry.DataConfig:TryGetNum("Treasure_map_hummer", "k2")
  end
  return self.nOpenSingleCost
end

function DigTreasureManager:UpdateActivityResetTime(nTime)
  if nTime then
    self.nResetTime = nTime
  end
end

function DigTreasureManager:GetActivityResetTime()
  return self.nResetTime or 0
end

function DigTreasureManager:GetShareMaxTimes()
  if not self.nShareMaxTimes then
    self.nShareMaxTimes = LuaEntry.DataConfig:TryGetNum("Treasure_map_hummer", "k3")
  end
  return self.nShareMaxTimes
end

function DigTreasureManager:GetShareCD()
  if not self.nShareCD then
    self.nShareCD = LuaEntry.DataConfig:TryGetNum("Treasure_map_hummer", "k4")
  end
  return self.nShareCD
end

function DigTreasureManager:OnGetDigTreasureData(message)
  self:ClearAllMapInfo()
  if message.gameEndTime then
    self.nResetTime = message.gameEndTime
  end
  if message.lastShareTime then
    self.nLastShareTime = message.lastShareTime
  end
  if message.helpInfo then
    self.tHelpInfo = message.helpInfo
  else
    self.tHelpInfo = nil
  end
  if message.mapBoxList then
    self:UpdateRewardData(message.mapBoxList)
  end
  if message.levelMap then
    self:UpdateNormalMapData(message.levelMap)
  end
  if message.timeLimitMap then
    self:UpdateTimeLimitMap(message.timeLimitMap)
  end
  if message.isHammerGetMax then
    self:UpdateHelpTimesIsMax(message.isHammerGetMax)
  end
  EventManager:GetInstance():Broadcast(EventId.DigTreasureUpdateActivityData)
end

function DigTreasureManager:GetHelpList()
  return self.tHelpInfo
end

function DigTreasureManager:ClearAllMapInfo()
  self.tNormalMapData = nil
  self.tTimeLimitMapData = nil
  self.tMapBoxList = nil
end

function DigTreasureManager:ClearTimeLimitMapInfo()
  self.tTimeLimitMapData = nil
end

function DigTreasureManager:UpdateNormalMapData(tMapData)
  local data = DiggingMapData.New()
  data:UpdateData(tMapData)
  self.tNormalMapData = data
end

function DigTreasureManager:GetNormalMapData()
  return self.tNormalMapData
end

function DigTreasureManager:UpdateTimeLimitMap(tMapData)
  local data = DiggingMapData.New()
  data:UpdateData(tMapData)
  self.tTimeLimitMapData = data
end

function DigTreasureManager:GetTimeLimitMapData()
  return self.tTimeLimitMapData
end

function DigTreasureManager:GetCurMapData()
  if self:IsHaveTimeLimitMap() then
    return self.tTimeLimitMapData
  else
    return self.tNormalMapData
  end
end

function DigTreasureManager:IsHaveTimeLimitMap()
  local nCurTime = UITimeManager:GetInstance():GetServerTime()
  local bIsDuringTimeLimit = self.tTimeLimitMapData and self.tTimeLimitMapData.endTime and nCurTime < self.tTimeLimitMapData.endTime
  local bNotGetReward = self.tTimeLimitMapData and self.tTimeLimitMapData.rewardState ~= DigRewardState.HaveGot
  return bIsDuringTimeLimit or bNotGetReward
end

function DigTreasureManager:OpenDigTreasureView()
  if not self:IsActivityOpen() then
    return
  end
  if not self.tNormalMapData and not self.tTimeLimitMapData then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDigTreasure)
end

function DigTreasureManager:UpdateRewardData(tRewardList)
  if not tRewardList then
    return
  end
  local bHaveChange = false
  local tNewRewardList = tRewardList
  self:SortRewardData(tNewRewardList)
  if self.tMapBoxList then
    for i = 1, #tNewRewardList do
      if tNewRewardList[i].rewardState ~= self.tMapBoxList[i].rewardState then
        bHaveChange = true
        break
      end
    end
  end
  self.tMapBoxList = tNewRewardList
  if bHaveChange then
    EventManager:GetInstance():Broadcast(EventId.DigTreasureUpdateRewardData)
  end
end

function DigTreasureManager:GetRewardData()
  return self.tMapBoxList
end

function DigTreasureManager:OpenBrick(uuid, nPos)
  local tCurMapData = self:GetCurMapData()
  if not tCurMapData or tCurMapData.uuid ~= uuid then
    return false
  end
  if self:IsHaveTimeLimitMap() and tCurMapData.rewardState == DigRewardState.NotBegin then
    self:ShowBeginTimeLimitMapWindow()
    return false
  end
  local nCount = self:GetUseItemNum()
  if nCount <= 0 then
    UIUtil.ShowTipsId("treasure_map_hummer_tips_01")
    return false
  end
  if not self:PreDeductUseItemNum() then
    UIUtil.ShowTipsId("treasure_map_hummer_tips_01")
    return false
  end
  local needCheck = false
  if not self:IsHaveTimeLimitMap() then
    tCurMapData.brickDicCheck[nPos] = true
    local getAll = true
    for i = 1, #tCurMapData.blockInfo do
      local tLevelConfig = DataCenter.DiggingDataTemplateManager:GetConfigData(tCurMapData.mapConfigId)
      local tBlockConfig = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(tCurMapData.blockInfo[i].bid)
      local get = false
      if tLevelConfig and tBlockConfig then
        get = DataCenter.DiggingDataManager:CheckBlockGet(tCurMapData.blockInfo[i].pos, tCurMapData.brickDicCheck, tLevelConfig.num_width, tBlockConfig.size_width, tBlockConfig.size_height)
      end
      if not get then
        getAll = false
        break
      end
    end
    needCheck = getAll
  end
  if needCheck then
    SFSNetwork.SendMessage(MsgDefines.DigTreasureGameOpenBlock, uuid, nPos, true)
    return false
  else
    SFSNetwork.SendMessage(MsgDefines.DigTreasureGameOpenBlock, uuid, nPos, false)
    return true
  end
end

function DigTreasureManager:OnOpenBrick(t)
  EventManager:GetInstance():Broadcast(EventId.DiggingGameOpen, t)
end

function DigTreasureManager:SortRewardData(tRewardList)
  if not tRewardList then
    return
  end
  table.sort(tRewardList, function(a, b)
    local tCfgA = DataCenter.DiggingDataTemplateManager:GetConfigData(a.mapConfigId)
    local tCfgB = DataCenter.DiggingDataTemplateManager:GetConfigData(b.mapConfigId)
    if tCfgA and tCfgB then
      return tCfgA.layer < tCfgB.layer
    end
  end)
end

function DigTreasureManager:UpdateHelpTimesIsMax(bIsMax)
  self.bIsHelpTimeMax = bIsMax or 0
end

function DigTreasureManager:IsHelpTimesMax()
  return self.bIsHelpTimeMax == 1
end

function DigTreasureManager:OnGiveUpTimeLimitMap()
  if self.tTimeLimitMapData then
    self.tTimeLimitMapData.rewardState = DigRewardState.Fail
    EventManager:GetInstance():Broadcast(EventId.DigTreasureGiveUp)
  end
end

function DigTreasureManager:CanShareNow()
  local nCurTime = UITimeManager:GetInstance():GetServerTime()
  local nLastShareTime = self.nLastShareTime or 0
  local nCd = self:GetShareCD()
  local nSecond = math.modf((nCurTime - nLastShareTime) / 1000)
  return nCd < nSecond
end

function DigTreasureManager:UpdateLastShareTime()
  self.nLastShareTime = UITimeManager:GetInstance():GetServerTime()
end

function DigTreasureManager:CheckIsShownPlot()
  local bShown = Setting:GetPrivateBool("DigTreasurePlotShown", false)
  if self:IsActivityOpen() and not bShown then
    Setting:SetPrivateBool("DigTreasurePlotShown", true)
    DataCenter.LWPlotManager:CheckPlotValidity()
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = 8163, hideMainUI = false})
  end
end

function DigTreasureManager:GetMaxLayer()
  if not self.nMaxLevel then
    self.nMaxLevel = LuaEntry.DataConfig:TryGetNum("Treasure_map_max_level", "k1")
  end
  return self.nMaxLevel
end

function DigTreasureManager:GetCurLayer()
  local tCurMapData = self:GetNormalMapData()
  if not tCurMapData then
    return 0
  end
  local nConfigId = tCurMapData.mapConfigId
  local tCfg = DataCenter.DiggingDataTemplateManager:GetConfigData(nConfigId)
  local nLayer = tCfg and tCfg.layer or 0
  return nLayer
end

function DigTreasureManager:GoToShare()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(900531)
    return
  end
  if not self:CanShareNow() then
    UIUtil.ShowTipsId("breakthough_tips_03")
    return
  end
  if self:IsHelpTimesMax() then
    UIUtil.ShowTipsId("treasure_map_help_06")
    return
  end
  if self.shareParam == nil then
    local shareParam = {}
    shareParam.msgName = MsgDefines.DigTreasureShare
    shareParam.tipsId = "treasure_map_help_08"
    self.shareParam = shareParam
  end
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonSimpleShareConfirm, {anim = true}, self.shareParam)
end

function DigTreasureManager:GetPreviewReward(nIndex)
  if self.tPreviewReward == nil then
    self.tPreviewReward = {}
    for i = 4, 1, -1 do
      local tData = LuaEntry.DataConfig:TryGetStr("Treasure_map_box_show", "k" .. i)
      if tData then
        local tList = string.split(tData, "|")
        local tInfo = {}
        local nLayer = tonumber(tList[1])
        local nRewardId = tonumber(tList[2])
        tInfo.nameStrId = Localization:GetString("treasure_map_reward_show_03", nLayer)
        local showCfg = LocalController:instance():getLine(TableName.RewardConfig, nRewardId)
        local allProp = 0
        local propTab = string.split(showCfg.rate, ";")
        local itemTab = string.split(showCfg.item, ";")
        local numTab = string.split(showCfg.num, ";")
        local index = string.find(showCfg.rate, "|")
        if index ~= nil then
          propTab = string.split(showCfg.rate, "|")
          itemTab = string.split(showCfg.item, "|")
          numTab = string.split(showCfg.num, "|")
          allProp = 100
        else
          for index, value in ipairs(propTab) do
            allProp = allProp + tonumber(value)
          end
        end
        tInfo.boxIconPath = string.format(LoadPath.UIDigTreasureSpritePath, "lyt_S3_xiusaiqi_jidongduiwabao_baoxiang_jin2")
        tInfo.rewardInfo = {}
        for j = 1, #propTab do
          local rewardItem = ActDispatchTreasureRewardItemTemplate.New()
          rewardItem:InitData(propTab[j] / allProp, itemTab[j], numTab[j])
          table.insert(tInfo.rewardInfo, rewardItem)
        end
        table.insert(self.tPreviewReward, tInfo)
      end
    end
  end
  if self.tPreviewReward[nIndex] then
    return self.tPreviewReward[nIndex]
  end
end

function DigTreasureManager:CheckIsShownPlotInDispatchTask()
  if self.tCfgPlotActList == nil then
    local strAct = LuaEntry.DataConfig:TryGetStr("treasure_map_guide_server", "k1")
    self.tCfgPlotActList = string.split(strAct, "|")
  end
  local bIsTarget = false
  for i, v in ipairs(self.tCfgPlotActList) do
    if v == self.nActivityId then
      bIsTarget = true
      break
    end
  end
  if not bIsTarget then
    return true
  end
  return CS.GameEntry.Setting:GetPrivateBool("DigPlotShownInDispatchTask", false)
end

function DigTreasureManager:StopDelayTimer()
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function DigTreasureManager:DelayShowBeginTimeLimitMapWindow()
  self:StopDelayTimer()
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.DigTreasureManager:ShowBeginTimeLimitMapWindow()
  end, 8)
end

function DigTreasureManager:ShowBeginTimeLimitMapWindow()
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIDigTreasure) then
    return
  end
  self:StopDelayTimer()
  local message = Localization:GetString("treasure_map_reward_tips_03")
  UIUtil.ShowMessage(message, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    if self.tTimeLimitMapData and self.tTimeLimitMapData.rewardState == DigRewardState.NotBegin then
      SFSNetwork.SendMessage(MsgDefines.DigTreasureGetTimeGameHammer, self.tTimeLimitMapData.uuid)
    end
  end)
end

function DigTreasureManager:GetExchangeInfo()
  if not self.tExchangeInfo then
    local sRate = LuaEntry.DataConfig:TryGetStr("Treasure_map_hummer", "k6")
    local tRate = string.split(sRate, "|")
    self.tExchangeInfo = {}
    self.tExchangeInfo[1] = {}
    self.tExchangeInfo[1].nItemId = self:GetUseItemId()
    self.tExchangeInfo[1].nCount = tonumber(tRate[1])
    self.tExchangeInfo[2] = {}
    self.tExchangeInfo[2].nItemId = self:GetExchangeTargetItemId()
    self.tExchangeInfo[2].nCount = tonumber(tRate[2])
  end
  return self.tExchangeInfo
end

function DigTreasureManager:GetExchangeTargetItemId()
  if not self.nExchangeTargetItemId then
    self.nExchangeTargetItemId = LuaEntry.DataConfig:TryGetNum("Treasure_map_hummer", "k5")
    self.nExchangeTargetItemId = tonumber(self.nExchangeTargetItemId)
  end
  return self.nExchangeTargetItemId
end

function DigTreasureManager:GetDigTreasurePreviewActEndTime()
  local tDataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.DigTreasurePreview.Type)
  if tDataList and tDataList[1] then
    return tDataList[1].endTime
  end
  return 0
end

function DigTreasureManager:GetAllTimeLimitMapReward(bIsGet)
  if not self.tTimeLimitMapData then
    return
  end
  local tBlockList = self.tTimeLimitMapData.blockInfo
  local rewardDict = {}
  for i, v in ipairs(tBlockList) do
    local bGet = v.getReward == DigTreasureBlockRewardState.HaveGot or not bIsGet
    if v.rewardInfo and v.rewardInfo[1] and bGet then
      local sId = v.rewardInfo[1].value.id
      local nType = v.rewardInfo[1].type
      local nNum = v.rewardInfo[1].value.num
      if rewardDict[sId] == nil then
        rewardDict[sId] = {}
        rewardDict[sId].id = sId
        rewardDict[sId].type = nType
        rewardDict[sId].num = nNum
      else
        rewardDict[sId].num = rewardDict[sId].num + nNum
      end
    end
  end
  local rewards = {}
  for k, v in pairs(rewardDict) do
    local rewardInfo = {}
    rewardInfo.type = v.type
    rewardInfo.value = {}
    rewardInfo.value.id = v.id
    rewardInfo.value.num = v.num
    table.insert(rewards, rewardInfo)
  end
  local message = {}
  message.reward = rewards
  return message
end

function DigTreasureManager:SetIsShowFailReward(bool)
  Setting:SetPrivateBool("IsShowFailReward", bool)
end

function DigTreasureManager:ShowTimeLimitMapRewardWhenFail()
  if not self.tTimeLimitMapData then
    return
  end
  local bShow = Setting:GetPrivateBool("IsShowFailReward", false)
  if not bShow then
    local message = self:GetAllTimeLimitMapReward(true)
    if message.reward and #message.reward > 0 then
      Setting:SetPrivateBool("IsShowFailReward", true)
      local str = Localization:GetString("treasure_map_reward_show_05")
      DataCenter.RewardManager:ShowCommonReward(message, nil, nil, nil, nil, nil, nil, str)
    end
  end
end

function DigTreasureManager:RefreshUseItemNum()
  self.nCacheItemNum = self:GetUseItemNum()
end

function DigTreasureManager:PreDeductUseItemNum()
  if not self.nCacheItemNum then
    self.nCacheItemNum = self:GetUseItemNum()
  end
  if self.nCacheItemNum <= 0 then
    local nCurNum = self:GetUseItemNum()
    return false
  end
  self.nCacheItemNum = self.nCacheItemNum - 1
  return true
end

return DigTreasureManager
