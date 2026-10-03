local base = UIBaseView
local UILWAlRankRewardPanelView = BaseClass("UILWAlRankRewardPanelView", base)
local Localization = CS.GameEntry.Localization
local UIRankingRewardItem = require("UI.UILWAlliance.UILWAlRankReward.Component.UIRankingRewardItem")
local UIGray = CS.UIGray
local bgPanelPath = "Panel"
local closeBtnPath = "UICommonPopUpTitle/CloseBtn"
local dailyRankingTogglePath = "Root/RankingToggles/dailyToggle"
local dailyRankingToggleTextPath = "Root/RankingToggles/dailyToggle/ToggleText1"
local weekRankingTogglePath = "Root/RankingToggles/weekToggle"
local weekRankingToggleTextPath = "Root/RankingToggles/weekToggle/ToggleText2"
local stageRankingPagePath = "Root/StageRankingPage"
local rankingScrollPath = "Root/RankingScroll"
local rankingScrollContentPath = "Root/RankingScroll/Viewport/Content"
local stageTogglePath = "Root/StageRankingPage/StageToggles/Stage%dToggle"
local stageToggleTextPath = "Root/StageRankingPage/StageToggles/Stage%dToggle/StageToggleText%d"
local titleTextPath = "UICommonPopUpTitle/Common_img_title/titleText"
local timeTxtPath = "Root/infoContent/TimeContent/timeTxt"
local timeNumTxtPath = "Root/infoContent/TimeContent/timeNumTxt"
local tipTxtPath = "Root/infoContent/tipTxt"
local infoBtnPath = "Root/infoContent/InfoBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnSelectPage(AllianceDonateRankType.RankDay)
end

local function ClearScroll(self)
  self.rankingScrollContent:RemoveComponents(UIRankingRewardItem)
  self.rankingScroll:ClearAllItems()
end

local function OnDestroy(self)
  ClearScroll(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.dataList then
    return nil
  end
  local data = self.dataList[index]
  local item = loopScroll:NewListViewItem("RankingRewardItem")
  local script = self.rankingScrollContent:GetComponent(item.gameObject.name, UIRankingRewardItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.rankingScrollContent:AddComponent(UIRankingRewardItem, objectName)
  end
  script:SetActive(true)
  script:SetData(data, false)
  return item
end

local function ComponentDefine(self)
  self.bgPanel = self:AddComponent(UIButton, bgPanelPath)
  self.bgPanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, closeBtnPath)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleN = self:AddComponent(UIText, titleTextPath)
  self.titleN:SetLocalText("455115")
  self.timeTxt = self:AddComponent(UIText, timeTxtPath)
  self.timeTxt:SetLocalText("455116")
  self.tipTxt = self:AddComponent(UIText, tipTxtPath)
  self.timeNumTxt = self:AddComponent(UIText, timeNumTxtPath)
  self.dailyRankingToggle = self:AddComponent(UIToggle, dailyRankingTogglePath)
  self.dailyRankingToggle:SetOnValueChanged(function(tf)
    if tf then
      self:OnSelectPage(AllianceDonateRankType.RankDay)
    end
  end)
  self.dailyRankingToggleText = self:AddComponent(UIText, dailyRankingToggleTextPath)
  self.dailyRankingToggleText:SetLocalText(390263)
  self.weekRankingToggle = self:AddComponent(UIToggle, weekRankingTogglePath)
  self.weekRankingToggle:SetOnValueChanged(function(tf)
    if tf then
      self:OnSelectPage(AllianceDonateRankType.RankWeek)
    end
  end)
  self.weekRankingToggleText = self:AddComponent(UIText, weekRankingToggleTextPath)
  self.weekRankingToggleText:SetLocalText(390207)
  self.rankingScroll = self:AddComponent(UILoopListView2, rankingScrollPath)
  self.rankingScroll:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.rankingScrollContent = self:AddComponent(UIBaseContainer, rankingScrollContentPath)
  self.infoBtn = self:AddComponent(UIButton, infoBtnPath)
  self.infoBtn:SetOnClick(function()
    self:OnHelpBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.bgPanel = nil
  self.closeBtn = nil
  self.titleN = nil
  self.dailyRankingToggle = nil
  self.weekRankingToggle = nil
  self.rankingScroll = nil
  self.rankingScrollContent = nil
  self.timeTxt = nil
  self.tipTxt = nil
  self.timeNumTxt = nil
  self.infoBtn = nil
end

local function DataDefine(self)
  self.itemIndex = 0
end

local function DataDestroy(self)
  self.itemIndex = nil
  self.curPageType = nil
end

local function OnSelectPage(self, newPageType)
  if self.curPageType == newPageType then
    return
  end
  self.curPageType = newPageType
  self:RefreshView()
end

local function RefreshView(self)
  self.dataList = {}
  self.endTime = 0
  if self.curPageType == AllianceDonateRankType.RankDay then
    self.dataList = DataCenter.AllianceDonateRankDataManager.rankDayList
    self.endTime = DataCenter.AllianceDonateRankDataManager.dayRefreshTime
    local num = LuaEntry.DataConfig:TryGetNum("guild_plus_sep", "k5")
    self.tipTxt:SetLocalText("311036", num)
  elseif self.curPageType == AllianceDonateRankType.RankWeek then
    self.dataList = DataCenter.AllianceDonateRankDataManager.rankWeekList
    self.endTime = DataCenter.AllianceDonateRankDataManager.weekRefreshTime
    local num = LuaEntry.DataConfig:TryGetNum("guild_plus_sep", "k6")
    self.tipTxt:SetLocalText("311036", num)
  end
  if #self.dataList == 0 then
    self.rankingScroll:SetActive(false)
  else
    self.rankingScroll:SetActive(true)
    self.rankingScroll:SetListItemCount(#self.dataList, false, false)
    self.rankingScroll:RefreshAllShownItem()
  end
  self:Update1000MS()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetAlDonateRankRewardGet, self.RefreshView)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetAlDonateRankRewardGet, self.RefreshView)
end

local sendMsgTime = 0

local function Update1000MS(self)
  if self.endTime == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = self.endTime - curTime
  if 0 < deltaTime then
    local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
    self.timeNumTxt:SetText(showTime)
  else
    self.timeNumTxt:SetText("")
    if curTime > sendMsgTime + 10000 then
      sendMsgTime = curTime
      SFSNetwork.SendMessage(MsgDefines.AlRankReward)
    end
  end
end

local function OnHelpBtnClick(self)
  if self.curPageType == AllianceDonateRankType.RankDay then
    local param = {}
    param.activityRulesStr = Localization:GetString(455117)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  elseif self.curPageType == AllianceDonateRankType.RankWeek then
    local param = {}
    param.activityRulesStr = Localization:GetString(455119)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

UILWAlRankRewardPanelView.OnCreate = OnCreate
UILWAlRankRewardPanelView.OnDestroy = OnDestroy
UILWAlRankRewardPanelView.ComponentDefine = ComponentDefine
UILWAlRankRewardPanelView.ComponentDestroy = ComponentDestroy
UILWAlRankRewardPanelView.DataDefine = DataDefine
UILWAlRankRewardPanelView.DataDestroy = DataDestroy
UILWAlRankRewardPanelView.OnAddListener = OnAddListener
UILWAlRankRewardPanelView.OnRemoveListener = OnRemoveListener
UILWAlRankRewardPanelView.OnSelectPage = OnSelectPage
UILWAlRankRewardPanelView.RefreshView = RefreshView
UILWAlRankRewardPanelView.OnHelpBtnClick = OnHelpBtnClick
UILWAlRankRewardPanelView.Update1000MS = Update1000MS
return UILWAlRankRewardPanelView
