local base = UIBaseView
local UIAllyDuelView = BaseClass("UIAllyDuelView", base)
local Localization = CS.GameEntry.Localization
local AllyDuelToday = "UI.UIAllyDuel.Component.AllyDuelToday.AllyDuelToday"
local AllyDuelHistory = "UI.UIAllyDuel.Component.AllyDuelHistory.AllyDuelHistoryNew"
local AlCompeteCrossDesertServerPanel = "UI.UIAllyDuel.Component.AllyDuelCrossServer.AlCompeteCrossDesertServerPanel"
local AllyDuelCrossServer = "UI.UIAllyDuel.Component.AllyDuelCrossServer.AllyDuelCrossServer"
local AllyDuelLeagueRank = "UI.UIAllyDuel.Component.AllyDuelLeagueRank.AllyDuelLeagueRank"
local AllyDuelLeagueNotice = "UI.UIAllyDuel.Component.AllyDuelLeagueNotice.AllyDuelLeagueNotice"
local UIAllyDuelScoreGachaSunday = "UI.UIAllyDuel.Component.AllyDuelScoreGachaSunday.UIAllyDuelScoreGachaSunday"
local TabName = {
  [LeagueMatchTab.Activity] = "372284",
  [LeagueMatchTab.GachaSunday] = "alliance_duel_gacha_tech_name",
  [LeagueMatchTab.Compete] = "361000",
  [LeagueMatchTab.CrossServer] = "110214",
  [LeagueMatchTab.CrossServerDesert] = "500001",
  [LeagueMatchTab.Notice] = "372617",
  [LeagueMatchTab.AllianceRank] = "372629"
}
local panelContainer_path = "safeArea/panelContainer"
local toggle_path = "safeArea/tabsSv/Viewport/Content/Toggle"
local assetsPath = "Assets/Main/Prefabs/UI/UIAllyDuel/%s.prefab"
local subPanelConf = {
  [LeagueMatchTab.Activity] = {
    Asset = "AllyDuelToday",
    Script = AllyDuelToday
  },
  [LeagueMatchTab.GachaSunday] = {
    Asset = "UIAllyDuelGachaSunday",
    Script = UIAllyDuelScoreGachaSunday
  },
  [LeagueMatchTab.Compete] = {
    Asset = "AllyDuelHistoryNew",
    Script = AllyDuelHistory
  },
  [LeagueMatchTab.Notice] = {
    Asset = "AllyDuelLeagueNotice",
    Script = AllyDuelLeagueNotice
  },
  [LeagueMatchTab.AllianceRank] = {
    Asset = "AllyDuelLeagueRank",
    Script = AllyDuelLeagueRank
  },
  [LeagueMatchTab.CrossServer] = {
    Asset = "AllyDuelCrossServer",
    Script = AllyDuelCrossServer
  },
  [LeagueMatchTab.CrossServerDesert] = {
    Asset = "AlCompeteCrossDesertServerPanel",
    Script = AlCompeteCrossDesertServerPanel
  }
}

function UIAllyDuelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
end

function UIAllyDuelView:OnDestroy()
  if self.refreshTimer then
    self.refreshTimer:Stop()
    self.refreshTimer = nil
  end
  DataCenter.AllianceCompeteDataManager:CacheOpeningTabIndex(self.curTabIndex)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIAllyDuelView:ComponentDefine()
  self.title = self:AddComponent(UIText, "safeArea/TopBar/TextTitle")
  self.title:SetLocalText(500002)
  self.closeBtnN = self:AddComponent(UIButton, "safeArea/BottomBar/BtnBack")
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.upgradeTechnologyBtn = self:AddComponent(UIButton, "safeArea/BottomBar/BtnUp")
  self.upgradeTechnologyBtn:SetOnClick(function()
    self:OnClickUpgradeTechnologyBtn()
  end)
  self.historyBtnTxtN = self:AddComponent(UIText, "safeArea/BottomBar/group/BtnHistory/TextHistory")
  self.historyBtnTxtN:SetLocalText(459010)
  self.historyBtn = self:AddComponent(UIButton, "safeArea/BottomBar/group/BtnHistory")
  self.historyBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickHistoryBtn()
  end)
  self.historyBtn:SetActive(false)
  self.rankBtnTxtN = self:AddComponent(UIText, "safeArea/BottomBar/group/BtnRank/TextRank")
  self.rankBtnTxtN:SetLocalText(361055)
  self.rankBtn = self:AddComponent(UIButton, "safeArea/BottomBar/group/BtnRank")
  self.rankBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickRankBtn()
  end)
  self.rankBtn:SetActive(false)
  self.rewardBtnTxtN = self:AddComponent(UIText, "safeArea/BottomBar/group/BtnReward/TextReward")
  if DataCenter.LeagueMatchManager:CheckIsMatchOpen() then
    self.rewardBtnTxtN:SetLocalText(372815)
  else
    self.rewardBtnTxtN:SetLocalText(361012)
  end
  self.rewardBtn = self:AddComponent(UIButton, "safeArea/BottomBar/group/BtnReward")
  self.rewardBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickRewardBtn()
  end)
  self.showNews3 = self:AddComponent(UIButton, "safeArea/tabs/Toggle3/showNew3")
  self.newsTxt3 = self:AddComponent(UIText, "safeArea/tabs/Toggle3/showNew3/showTxt3")
  self.showNews4 = self:AddComponent(UIButton, "safeArea/tabs/Toggle4/showNew4")
  self.newsTxt4 = self:AddComponent(UIText, "safeArea/tabs/Toggle4/showNew4/showTxt4")
  self.newsTxt3:SetLocalText(302049)
  self.newsTxt4:SetLocalText(302049)
  self.showNews3:SetActive(false)
  self.showNews4:SetActive(false)
  self.panelContainerN = self:AddComponent(UIBaseContainer, panelContainer_path)
  self.togglesTbN = {}
  for i = 1, 7 do
    local tempPath = toggle_path .. i
    local toggle = self:AddComponent(UIButton, tempPath)
    toggle:SetOnClick(function()
      self:ChangeShowType(i)
    end)
    local newTog = {}
    newTog.toggleN = toggle
    newTog.chooseN = toggle:AddComponent(UIBaseContainer, "select")
    newTog.redN = toggle:AddComponent(UIBaseContainer, "RedPoint")
    newTog.redNumN = toggle:AddComponent(UIText, "RedPoint/RedNum")
    newTog.nameN = toggle:AddComponent(UIText, "activityName")
    newTog.showNewN = toggle:AddComponent(UIBaseContainer, "NewDot")
    newTog.showNewN:SetActive(false)
    newTog.ShowNewTxtN = toggle:AddComponent(UIText, "NewDot/Bg/Text")
    if i == LeagueMatchTab.CrossServer then
      newTog.ShowNewTxtN:SetLocalText(302049)
    elseif i == LeagueMatchTab.CrossServerDesert then
      newTog.ShowNewTxtN:SetLocalText(302049)
    end
    table.insert(self.togglesTbN, newTog)
  end
  local theLastIndex = LeagueMatchTab.CrossServerDesert
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if actInfo then
    local eventInfo = actInfo:GetEventInfo()
    if eventInfo ~= nil then
      local fightStartTime = eventInfo.fightStartTime
      local desertFightStartTime = eventInfo.desertFightStartTime
      local fightEndTime = eventInfo.fightEndTime
      local desertFightEndTime = eventInfo.desertFightEndTime
      if fightStartTime ~= nil and desertFightStartTime ~= nil then
        if fightStartTime > desertFightStartTime then
          theLastIndex = LeagueMatchTab.CrossServer
        else
          theLastIndex = LeagueMatchTab.CrossServerDesert
        end
      end
      local serverTime = UITimeManager:GetInstance():GetServerTime()
      if desertFightStartTime ~= nil and desertFightEndTime ~= nil and desertFightStartTime < serverTime and desertFightEndTime > serverTime then
        self.togglesTbN[LeagueMatchTab.CrossServerDesert].showNewN:SetActive(true)
      end
      if fightStartTime ~= nil and fightEndTime ~= nil and fightStartTime < serverTime and fightEndTime > serverTime then
        self.togglesTbN[LeagueMatchTab.CrossServer].showNewN:SetActive(true)
      end
    end
  end
  local togglesLast = self.togglesTbN[theLastIndex]
  if togglesLast ~= nil and togglesLast.toggleN ~= nil and togglesLast.toggleN.transform ~= nil then
    togglesLast.toggleN.transform:SetSiblingIndex(LeagueMatchTab.CrossServerDesert)
  end
end

function UIAllyDuelView:ComponentDestroy()
  CS.DynamicFPSConfig.FreeHighFPSLockerForChildrenScrollComponents(self.panelContainerN.gameObject)
  self.closeBtnN = nil
  self.historyBtn = nil
  self.rankBtnN = nil
  self.rewardBtnN = nil
  self.togglesTbN = nil
  self.infoBtnN = nil
  self.panelContainerN = nil
  self.historyBtnTxtN = nil
  self.rankBtnTxtN = nil
  self.rewardBtnTxtN = nil
end

function UIAllyDuelView:DataDefine()
  self.panelList = {}
  self.reqList = {}
  self.curTabIndex = nil
  self.targetTabIndex = nil
  local now = UITimeManager:GetInstance():GetServerTime()
  CommonUtil.PlayerPrefsSetLong("LAST_OPEN_TIMESTAMP_" .. EnumActivity.AllianceCompete.ActId, now)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function UIAllyDuelView:DataDestroy()
  self:RecordRedPoint()
  self.panelList = nil
  self.reqList = nil
  self.curTabIndex = nil
  self.targetTabIndex = nil
end

function UIAllyDuelView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.OnRefreshCallback)
  self:AddUIListener(EventId.OnMyLeagueMatchInfoUpdate, self.RefreshAll)
  self:AddUIListener(EventId.OnLeagueMatchBaseInfoUpdate, self.RefreshAll)
  self:AddUIListener(EventId.AllianceApplySuccess, self.DelayRefreshAll)
  self:AddUIListener(EventId.OnPassDay, self.DelayRefreshAll)
  self:AddUIListener(EventId.AllyDuelLeagueStart, self.AllyDuelLeagueStart)
  self:AddUIListener(EventId.AllyDuelLeagueToday, self.OnAllyDuelLeagueToday)
  self:AddUIListener(EventId.AllyDuelChangeTabInView, self.OnAllyDuelChangeTabInView)
  self:AddUIListener(EventId.AllyDuelScoreGachaWishClaim, self.RefreshRed)
  self:AddUIListener(EventId.AllyDuelScoreGachaUpdateScore, self.RefreshRed)
end

function UIAllyDuelView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.OnRefreshCallback)
  self:RemoveUIListener(EventId.OnMyLeagueMatchInfoUpdate, self.RefreshAll)
  self:RemoveUIListener(EventId.OnLeagueMatchBaseInfoUpdate, self.RefreshAll)
  self:RemoveUIListener(EventId.AllianceApplySuccess, self.DelayRefreshAll)
  self:RemoveUIListener(EventId.OnPassDay, self.DelayRefreshAll)
  self:RemoveUIListener(EventId.AllyDuelLeagueStart, self.AllyDuelLeagueStart)
  self:RemoveUIListener(EventId.AllyDuelLeagueToday, self.OnAllyDuelLeagueToday)
  self:RemoveUIListener(EventId.AllyDuelChangeTabInView, self.OnAllyDuelChangeTabInView)
  self:RemoveUIListener(EventId.AllyDuelScoreGachaWishClaim, self.RefreshRed)
  self:RemoveUIListener(EventId.AllyDuelScoreGachaUpdateScore, self.RefreshRed)
  base.OnRemoveListener(self)
end

function UIAllyDuelView:InitUI()
  local hasAlliance = LuaEntry.Player:IsInAlliance()
  if hasAlliance then
    local leagueMatchStage = DataCenter.LeagueMatchManager:GetLeagueMatchStage()
    if leagueMatchStage ~= LeagueMatchStage.None then
      DataCenter.LeagueMatchManager:GetMyMatchInfoReq()
      DataCenter.LeagueMatchManager:TryUpdateLeagueMatchGroup()
    end
    SFSNetwork.SendMessage(MsgDefines.AllianceCompeteRankList, 0)
  end
  local targetTabIndex, boxIndex = self:GetUserData()
  targetTabIndex = targetTabIndex or DataCenter.AllianceCompeteDataManager:GetDefaultOpenTabIndex()
  targetTabIndex = targetTabIndex or LeagueMatchTab.Activity
  targetTabIndex = self:RefreshTabs(targetTabIndex, boxIndex)
  if not targetTabIndex then
    TimerManager:GetInstance():DelayInvoke(function()
      if self.ctrl and self.ctrl.CloseSelf then
        self.ctrl:CloseSelf()
      end
    end, 0.5)
    return
  end
  self:ChangeShowType(targetTabIndex)
  self:RefreshRed()
end

function UIAllyDuelView:RefreshAll()
  local tempIndex = self:RefreshTabs(self.curTabIndex or self.targetTabIndex)
  if not tempIndex then
    self.ctrl:CloseSelf()
    return
  end
  self:ChangeShowType(tempIndex)
  self:RefreshRed()
end

function UIAllyDuelView:AllyDuelLeagueStart()
  local tempIndex = self:RefreshTabs(LeagueMatchTab.AllianceRank)
  if not tempIndex then
    self.ctrl:CloseSelf()
    return
  end
  self:ChangeShowType(tempIndex)
  self:RefreshRed()
end

function UIAllyDuelView:OnAllyDuelLeagueToday()
  local tempIndex = self:RefreshTabs(LeagueMatchTab.Activity)
  if not tempIndex then
    self.ctrl:CloseSelf()
    return
  end
  self:ChangeShowType(tempIndex)
  self:RefreshRed()
end

function UIAllyDuelView:OnAllyDuelChangeTabInView(tabIndex)
  if self.ctrl:CheckIfTabIsVisible(tabIndex) then
    self.targetTabIndex = tabIndex
    self:ChangeShowType(self.targetTabIndex)
  end
end

function UIAllyDuelView:RefreshTabs(targetTabIndex, boxIndex)
  for i, v in ipairs(self.togglesTbN) do
    v.nameN:SetText(TabName[i] and Localization:GetString(TabName[i]) or "")
    if self.ctrl:CheckIfTabIsVisible(i) then
      v.isVisible = true
      v.toggleN:SetActive(true)
      if i == LeagueMatchTab.Compete then
      end
    else
      v.isVisible = false
      v.toggleN:SetActive(false)
      if i == LeagueMatchTab.Compete then
      end
    end
  end
  local theLastIndex = LeagueMatchTab.CrossServerDesert
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if actInfo then
    local eventInfo = actInfo:GetEventInfo()
    if eventInfo ~= nil then
      local fightStartTime = eventInfo.fightStartTime
      local desertFightStartTime = eventInfo.desertFightStartTime
      if fightStartTime ~= nil and desertFightStartTime ~= nil then
        if fightStartTime > desertFightStartTime then
          theLastIndex = LeagueMatchTab.CrossServer
        else
          theLastIndex = LeagueMatchTab.CrossServerDesert
        end
      end
    end
  end
  local togglesLast = self.togglesTbN[theLastIndex]
  if togglesLast ~= nil and togglesLast.toggleN ~= nil and togglesLast.toggleN.transform ~= nil then
    togglesLast.toggleN.transform:SetAsLastSibling()
  end
  targetTabIndex = targetTabIndex or 1
  self.boxIndex = nil
  if not self.togglesTbN[targetTabIndex].isVisible then
    local needCloseUI = true
    for i, v in ipairs(self.togglesTbN) do
      if v.isVisible then
        targetTabIndex = i
        needCloseUI = false
        break
      end
    end
    if needCloseUI then
      return nil
    end
  end
  if targetTabIndex == 1 and boxIndex and boxIndex ~= 0 then
    self.boxIndex = boxIndex
  end
  return targetTabIndex
end

function UIAllyDuelView:OnRefreshCallback()
  self:RefreshRed()
end

function UIAllyDuelView:DelayRefreshAll()
  self.refreshTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.refreshTimer = nil
    local tempStage = DataCenter.LeagueMatchManager:GetLeagueMatchStage()
    if tempStage == LeagueMatchStage.WeeklySummary or tempStage == LeagueMatchStage.FinalSummary then
      self:OnClickCloseBtn()
    else
      self:RefreshAll()
    end
  end, 3)
end

function UIAllyDuelView:RefreshRed()
  for i, v in ipairs(self.togglesTbN) do
    local redCount = self:GetRedCountByType(i)
    if redCount and 0 < redCount then
      v.redN:SetActive(true)
      v.redNumN:SetText(99 < redCount and "99+" or redCount)
    else
      v.redN:SetActive(false)
    end
  end
end

function UIAllyDuelView:GetRedCountByType(tabType)
  if tabType == LeagueMatchTab.Activity then
    local redCount = DataCenter.AllianceCompeteDataManager:GetAlCompeteActivityRedCount()
    redCount = redCount + DataCenter.AllyDuelScoreGachaManager:GetTotalRedDotNum()
    return redCount
  elseif tabType == LeagueMatchTab.GachaSunday then
    local redCount = DataCenter.AllyDuelScoreGachaManager:GetTotalRedDotNum()
    return redCount
  else
    return 0
  end
end

function UIAllyDuelView:FixAsset(idx)
  local prefabName = subPanelConf[idx].Asset
  return prefabName
end

function UIAllyDuelView:FixScript(idx)
  local script = subPanelConf[idx].Script
  return script
end

function UIAllyDuelView:ChangeShowType(tabIndex)
  self.targetTabIndex = tabIndex
  for i = 1, #self.togglesTbN do
    self.togglesTbN[i].chooseN:SetActive(i == tabIndex)
  end
  local showBBtn = self.targetTabIndex == LeagueMatchTab.Activity or self.targetTabIndex == LeagueMatchTab.Compete
  local showRank = DataCenter.AllianceCompeteDataManager:IsShowRankBtn() and self.targetTabIndex ~= LeagueMatchTab.GachaSunday
  local showHistory = self.targetTabIndex == LeagueMatchTab.AllianceRank
  self.rewardBtn:SetActive(showBBtn)
  self.rankBtn:SetActive(showRank ~= false and showRank ~= nil)
  self.historyBtn:SetActive(showHistory)
  local prefabName = self:FixAsset(tabIndex)
  self.upgradeTechnologyBtn:SetActive(DataCenter.AllianceCompeteDataManager:GetScienceTip())
  if self.curTabIndex and prefabName == self:FixAsset(self.curTabIndex) then
    self.curTabIndex = tabIndex
    self:RefreshOnShowPanel()
  elseif not self.panelList[prefabName] then
    if self.reqList[prefabName] then
      return
    end
    local assetFullPath = string.format(assetsPath, prefabName)
    self.reqList[prefabName] = self:GameObjectInstantiateAsync(assetFullPath, function(request)
      if request.isError then
        return
      end
      if self.curTabIndex then
        local panel = self.panelList[self:FixAsset(self.curTabIndex)]
        if panel then
          panel:SetActive(false)
        end
      end
      self.curTabIndex = tabIndex
      local go = request.gameObject
      go.transform:SetParent(self.panelContainerN.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local v3 = go.transform.position
      v3.x = 0
      v3.y = 0
      go.transform.position = v3
      local cls = require(self:FixScript(tabIndex))
      local cell = self.panelContainerN:AddComponent(cls, go)
      cell:SetOffsetMinXY(0, 0)
      cell:SetOffsetMaxXY(0, 0)
      self.panelList[prefabName] = cell
      self.panelList[prefabName]:SetActive(true)
      self:RefreshOnShowPanel()
      CS.DynamicFPSConfig.AcquireHighFPSLockerForChildrenScrollComponents(go)
    end)
  else
    if self.curTabIndex then
      self.panelList[self:FixAsset(self.curTabIndex)]:SetActive(false)
    end
    self.curTabIndex = tabIndex
    self.panelList[prefabName]:SetActive(true)
    self:RefreshOnShowPanel()
  end
end

function UIAllyDuelView:RefreshOnShowPanel()
  local tempPanel = self:FixAsset(self.curTabIndex)
  local showType = self.curTabIndex
  self.panelList[tempPanel]:ShowPanel(showType)
end

function UIAllyDuelView:CheckIfDoubleReward()
  local effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.EFFECT_ONE_MORE_TIMES)
  if effectNum and 0 < effectNum then
    return true
  end
end

function UIAllyDuelView:OnClickCloseBtn()
  self.ctrl:CloseSelf()
end

function UIAllyDuelView:OnClickUpgradeTechnologyBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDuelScienceTip)
end

function UIAllyDuelView:OnClickHistoryBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDuelLeagueHistory, {anim = true})
end

function UIAllyDuelView:OnClickRankBtn()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local weekday = UITimeManager:GetInstance():GetWeekdayIndex(curTime)
  if weekday == 7 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIAllyDuelPersonalRankPanel, {anim = true}, 2)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIAllyDuelPersonalRankPanel, {anim = true}, 1)
  end
end

function UIAllyDuelView:OnClickRewardBtn()
  local isMatchOpen = DataCenter.LeagueMatchManager:CheckIsMatchOpen()
  if not isMatchOpen then
  else
    local targetTab = self.curTabIndex == LeagueMatchTab.AllianceRank and 3 or 1
    local targetSeg = DataCenter.LeagueMatchManager:GetSegment()
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIAllyDuelRewardPanel, {anim = true}, targetTab, targetSeg)
  end
end

function UIAllyDuelView:RecordRedPoint()
  local alCompeteRedCount, reward, tip = DataCenter.AllianceCompeteDataManager:GetAlCompeteteTotalRedCount()
  local gachaRedNum = DataCenter.AllyDuelScoreGachaManager:GetTotalRedDotNum()
  local zeroTime = UITimeManager:GetInstance():GetTomorrowZero()
  CommonUtil.PlayerPrefsSetInt(SettingKeys.ALLY_DUEL_BTN_TOTAL_LAST_RED .. zeroTime, alCompeteRedCount + gachaRedNum)
  EventManager:GetInstance():Broadcast(EventId.AllyDuelBtnRedPointUpdate)
end

return UIAllyDuelView
