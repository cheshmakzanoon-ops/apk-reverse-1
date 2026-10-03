local DetectDigTreasureManager = BaseClass("DetectDigTreasureManager", CEventable)
local Localization = CS.GameEntry.Localization

function DetectDigTreasureManager:SetCurData(tDetectData)
  self.tCurDetectData = tDetectData
  self.tCurMapData = tDetectData.digGameInfo
end

function DetectDigTreasureManager:OpenBrick(nPos)
  local nCount = self:GetUseItemNum()
  if nCount <= 0 then
    UIUtil.ShowTipsId("treasure_map_hummer_tips_01")
    return false
  end
  if not self.tCurDetectData or not self.tCurMapData then
    return
  end
  local nEventUuid = self.tCurDetectData.uuid
  SFSNetwork.SendMessage(MsgDefines.DetectEventDigGameOpenBlock, nEventUuid, nPos)
end

function DetectDigTreasureManager:ReceiveFreeHammer()
  if not (self.tCurDetectData and self.tCurMapData) or self.tCurMapData.rewardState ~= DigRewardState.NotBegin then
    return
  end
  local nEventUuid = self.tCurDetectData.uuid
  SFSNetwork.SendMessage(MsgDefines.DetectEventDigGameReceiveHammer, nEventUuid)
end

function DetectDigTreasureManager:CheckIsShowGuide()
  local bIsShow = Setting:GetPrivateBool(SettingKeys.DETECT_DIG_TREASURE_GUIDE_SHOWN, false)
  return bIsShow
end

function DetectDigTreasureManager:OnGetFreeHammer(isPlayAnim)
  if self.tCurMapData and self.tCurMapData.rewardState == DigRewardState.NotBegin then
    self.tCurMapData.rewardState = DigRewardState.CanNotGet
  end
  if isPlayAnim then
    EventManager:GetInstance():Broadcast(EventId.OnGetFreeHammer)
  end
end

function DetectDigTreasureManager:OnOpenBrick(t)
  if not self:CheckIsShowGuide() then
    Setting:SetPrivateBool(SettingKeys.DETECT_DIG_TREASURE_GUIDE_SHOWN, true)
  end
  EventManager:GetInstance():Broadcast(EventId.DetectDigGameOpen, t)
end

function DetectDigTreasureManager:GetReward()
  if not self.tCurDetectData or not self.tCurMapData then
    return
  end
  local nEventUuid = self.tCurDetectData.uuid
  SFSNetwork.SendMessage(MsgDefines.DetectEventGetDigGameReward, nEventUuid)
end

function DetectDigTreasureManager:OnGetReward(uuid)
  if self.tCurDetectData and self.tCurMapData and self.tCurDetectData.uuid == uuid then
    self.tCurMapData.rewardState = DigRewardState.HaveGot
  end
end

function DetectDigTreasureManager:IsActivityOpen()
  local tDataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.DigTreasure.Type)
  if tDataList and tDataList[1] and DataCenter.ActivityListDataManager:CheckIsSend(tDataList[1]) then
    return true
  end
  return false
end

function DetectDigTreasureManager:GetUseItemId()
  if not self.nUseItemId then
    self.nUseItemId = LuaEntry.DataConfig:TryGetNum("early_digging_hummer", "k1")
  end
  return self.nUseItemId
end

function DetectDigTreasureManager:GetUseItemNum()
  local nId = self:GetUseItemId()
  local tItemInfo = DataCenter.ItemData:GetItemById(nId)
  if not tItemInfo then
    return 0
  end
  return tItemInfo.count
end

function DetectDigTreasureManager:GetOpenBlockSingleCost()
  if not self.nOpenSingleCost then
    self.nOpenSingleCost = LuaEntry.DataConfig:TryGetNum("early_digging_hummer", "k2")
  end
  return self.nOpenSingleCost
end

function DetectDigTreasureManager:UpdateActivityResetTime(nTime)
  if nTime then
    self.nResetTime = nTime
  end
end

function DetectDigTreasureManager:GetActivityResetTime()
  return self.nResetTime or 0
end

function DetectDigTreasureManager:GetShareMaxTimes()
  if not self.nShareMaxTimes then
    self.nShareMaxTimes = LuaEntry.DataConfig:TryGetNum("Treasure_map_hummer", "k3")
  end
  return self.nShareMaxTimes
end

function DetectDigTreasureManager:GetShareCD()
  if not self.nShareCD then
    self.nShareCD = LuaEntry.DataConfig:TryGetNum("Treasure_map_hummer", "k4")
  end
  return self.nShareCD
end

function DetectDigTreasureManager:OnGetDigTreasureData(message)
  self:ClearAllMapInfo()
  if message.gameEndTime then
    self.nResetTime = message.gameEndTime
  end
  if message.lastShareTime then
    self.nLastShareTime = message.lastShareTime
  end
  if message.helpInfo then
    self.tHelpInfo = message.helpInfo
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

function DetectDigTreasureManager:GetHelpList()
  return self.tHelpInfo
end

function DetectDigTreasureManager:ClearAllMapInfo()
  self.tNormalMapData = nil
  self.tTimeLimitMapData = nil
  self.tMapBoxList = nil
end

function DetectDigTreasureManager:ClearTimeLimitMapInfo()
  self.tTimeLimitMapData = nil
end

function DetectDigTreasureManager:UpdateNormalMapData(tMapData)
  local data = DiggingMapData.New()
  data:UpdateData(tMapData)
  self.tNormalMapData = data
end

function DetectDigTreasureManager:GetNormalMapData()
  return self.tNormalMapData
end

function DetectDigTreasureManager:UpdateTimeLimitMap(tMapData)
  local data = DiggingMapData.New()
  data:UpdateData(tMapData)
  self.tTimeLimitMapData = data
end

function DetectDigTreasureManager:GetTimeLimitMapData()
  return self.tTimeLimitMapData
end

function DetectDigTreasureManager:GetCurMapData()
  if self:IsHaveTimeLimitMap() then
    return self.tTimeLimitMapData
  else
    return self.tNormalMapData
  end
end

function DetectDigTreasureManager:IsHaveTimeLimitMap()
  local nCurTime = UITimeManager:GetInstance():GetServerTime()
  local bIsDuringTimeLimit = self.tTimeLimitMapData and self.tTimeLimitMapData.endTime and nCurTime < self.tTimeLimitMapData.endTime
  local bNotGetReward = self.tTimeLimitMapData and self.tTimeLimitMapData.rewardState ~= DigRewardState.HaveGot
  return bIsDuringTimeLimit or bNotGetReward
end

function DetectDigTreasureManager:OpenDigTreasureView()
  if not self:IsActivityOpen() then
    return
  end
  if not self.tNormalMapData and not self.tTimeLimitMapData then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDigTreasure)
end

function DetectDigTreasureManager:UpdateRewardData(tRewardList)
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

function DetectDigTreasureManager:GetRewardData()
  return self.tMapBoxList
end

function DetectDigTreasureManager:SortRewardData(tRewardList)
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

function DetectDigTreasureManager:UpdateHelpTimesIsMax(bIsMax)
  self.bIsHelpTimeMax = bIsMax or 0
end

function DetectDigTreasureManager:IsHelpTimesMax()
  return self.bIsHelpTimeMax == 1
end

function DetectDigTreasureManager:OnGiveUpTimeLimitMap()
  if self.tTimeLimitMapData then
    self.tTimeLimitMapData.rewardState = DigRewardState.Fail
    EventManager:GetInstance():Broadcast(EventId.DigTreasureGiveUp)
  end
end

function DetectDigTreasureManager:CanShareNow()
  local nCurTime = UITimeManager:GetInstance():GetServerTime()
  local nLastShareTime = self.nLastShareTime or 0
  local nCd = self:GetShareCD()
  local nSecond = math.modf((nCurTime - nLastShareTime) / 1000)
  return nCd < nSecond
end

function DetectDigTreasureManager:UpdateLastShareTime()
  self.nLastShareTime = UITimeManager:GetInstance():GetServerTime()
end

function DetectDigTreasureManager:CheckIsShownPlot()
  local bShown = Setting:GetPrivateBool("DigTreasurePlotShown", false)
  if self:IsActivityOpen() and not bShown then
    Setting:SetPrivateBool("DigTreasurePlotShown", true)
    DataCenter.LWPlotManager:CheckPlotValidity()
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = 8163, hideMainUI = false})
  end
end

function DetectDigTreasureManager:GetMaxLayer()
  if not self.nMaxLevel then
    self.nMaxLevel = LuaEntry.DataConfig:TryGetNum("Treasure_map_max_level", "k1")
  end
  return self.nMaxLevel
end

function DetectDigTreasureManager:GetCurLayer()
  local tCurMapData = self:GetNormalMapData()
  if not tCurMapData then
    return 0
  end
  local nConfigId = tCurMapData.mapConfigId
  local tCfg = DataCenter.DiggingDataTemplateManager:GetConfigData(nConfigId)
  local nLayer = tCfg and tCfg.layer or 0
  return nLayer
end

function DetectDigTreasureManager:GoToShare()
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

function DetectDigTreasureManager:GetPreviewReward(nIndex)
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

function DetectDigTreasureManager:CheckIsShownPlotInDispatchTask()
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

return DetectDigTreasureManager
