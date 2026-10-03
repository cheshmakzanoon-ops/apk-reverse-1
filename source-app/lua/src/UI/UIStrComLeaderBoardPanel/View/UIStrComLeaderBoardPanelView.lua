local base = UIBaseView
local UIStrComLeaderBoardPanelView = BaseClass("UIStrComLeaderBoardPanelView", base)
local Localization = CS.GameEntry.Localization
local UIPlayerRankingItem = require("UI.UIStrComLeaderBoardPanel.Component.UIPlayerRankingItem")
local UIGray = CS.UIGray
local bgPanelPath = "Panel"
local closeBtnPath = "UICommonPopUpTitle/CloseBtn"
local stageRankingTogglePath = "Root/RankingToggles/StageRankingToggle"
local stageRankingToggleTextPath = "Root/RankingToggles/StageRankingToggle/ToggleText1"
local totalRankingTogglePath = "Root/RankingToggles/TotalRankingToggle"
local totalRankingToggleTextPath = "Root/RankingToggles/TotalRankingToggle/ToggleText2"
local stageRankingPagePath = "Root/StageRankingPage"
local rankingScrollPath = "Root/RankingScroll"
local rankingScrollContentPath = "Root/RankingScroll/Viewport/Content"
local stageTogglePath = "Root/StageRankingPage/StageToggles/Stage%dToggle"
local stageToggleTextPath = "Root/StageRankingPage/StageToggles/Stage%dToggle/StageToggleText%d"
local rankingRewardsBtnPath = "Root/RankingRewardsBtn"
local selfPlayerRankingItemPath = "Root/selfPlayerItem"
LeaderBoardPageType = {
  None = 0,
  StageRanking = 1,
  TotalRanking = 2
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local activityId, stageId, maxStage = self:GetUserData()
  self.actId = activityId
  self.maxStage = maxStage
  if not self.actId then
    self.ctrl:CloseSelf()
    return
  end
  for i = 1, #self.stageToggles do
    local canClick = true
    if self.maxStage and self.maxStage ~= -1 then
      canClick = i <= self.maxStage
    end
    self.stageToggles[i]:SetInteractable(canClick)
  end
  if stageId and stageId ~= -1 then
    local pageToggleState = self.stageRankingToggle:GetIsOn()
    if not pageToggleState then
      self.stageRankingToggle:SetIsOn(true)
    else
      self:OnSelectPage(LeaderBoardPageType.StageRanking)
    end
    local toggleState = self.stageToggles[stageId]:GetIsOn()
    if toggleState then
      self:OnSelectStage(stageId)
    else
      self.stageToggles[stageId]:SetIsOn(true)
    end
  else
    local pageToggleState = self.totalRankingToggle:GetIsOn()
    if not pageToggleState then
      self.totalRankingToggle:SetIsOn(true)
    else
      self:OnSelectPage(LeaderBoardPageType.TotalRanking)
    end
  end
  self:UnlockPanel()
end

local function ClearScroll(self)
  self.rankingScrollContent:RemoveComponents(UIPlayerRankingItem)
  self.rankingScroll:ClearAllItems()
end

local function OnDestroy(self)
  ClearScroll(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function LockPanel(self)
  self.locked = true
  self.stageRankingToggle:SetInteractable(false)
  self.totalRankingToggle:SetInteractable(false)
  for i = 1, #self.stageToggles do
    self.stageToggles[i]:SetInteractable(false)
  end
  self.rankingRewardsBtn:SetInteractable(false)
end

local function UnlockPanel(self)
  self.locked = false
  self.stageRankingToggle:SetInteractable(true)
  self.totalRankingToggle:SetInteractable(true)
  for i = 1, #self.stageToggles do
    local canClick = true
    if self.maxStage and self.maxStage ~= -1 then
      canClick = i <= self.maxStage
    end
    self.stageToggles[i]:SetInteractable(canClick)
  end
  self.rankingRewardsBtn:SetInteractable(true)
end

local function RequstRankingData(self, pageType, stageId)
  if pageType == LeaderBoardPageType.StageRanking then
    SFSNetwork.SendMessage(MsgDefines.ActivityGetRankInfo, self.actId, 1, 100, stageId)
  elseif pageType == LeaderBoardPageType.TotalRanking then
    SFSNetwork.SendMessage(MsgDefines.ActivityGetRankInfo, self.actId, 1, 100, -1)
  end
  self.hasSentFirstRequest = true
  LockPanel(self)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.dataList then
    return nil
  end
  local data = self.dataList[index]
  local item = loopScroll:NewListViewItem("LeaderBoardPlayerItem")
  local script = self.rankingScrollContent:GetComponent(item.gameObject.name, UIPlayerRankingItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.rankingScrollContent:AddComponent(UIPlayerRankingItem, objectName)
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
  self.stageRankingToggle = self:AddComponent(UIToggle, stageRankingTogglePath)
  self.stageRankingToggle:SetOnValueChanged(function(tf)
    if tf then
      self:OnSelectPage(LeaderBoardPageType.StageRanking)
    end
  end)
  self.stageRankingToggleText = self:AddComponent(UIText, stageRankingToggleTextPath)
  self.totalRankingToggle = self:AddComponent(UIToggle, totalRankingTogglePath)
  self.totalRankingToggle:SetOnValueChanged(function(tf)
    if tf then
      self:OnSelectPage(LeaderBoardPageType.TotalRanking)
    end
  end)
  self.totalRankingToggleText = self:AddComponent(UIText, totalRankingToggleTextPath)
  self.stageRankingPage = self:AddComponent(UIBaseContainer, stageRankingPagePath)
  self.rankingScroll = self:AddComponent(UILoopListView2, rankingScrollPath)
  self.rankingScroll:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.rankingScrollContent = self:AddComponent(UIBaseContainer, rankingScrollContentPath)
  self.stageToggles = {}
  self.stageTogglesText = {}
  for i = 1, 7 do
    local stageToggle = self:AddComponent(UIToggle, string.format(stageTogglePath, i))
    stageToggle:SetOnValueChanged(function(tf)
      if tf then
        self:OnSelectStage(i)
      end
    end)
    table.insert(self.stageToggles, stageToggle)
    local stageToggleText = self:AddComponent(UIText, string.format(stageToggleTextPath, i, i))
    table.insert(self.stageTogglesText, stageToggleText)
  end
  self.rankingRewardsBtn = self:AddComponent(UIButton, rankingRewardsBtnPath)
  self.rankingRewardsBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIStrComRankingRewardPanel, {anim = true}, self.actId, self.curStageId, self.maxStage)
  end)
  self.selfPlayerRankingItem = self:AddComponent(UIPlayerRankingItem, selfPlayerRankingItemPath)
end

local function ComponentDestroy(self)
  self.bgPanel = nil
  self.closeBtn = nil
  self.stageRankingToggle = nil
  self.totalRankingToggle = nil
  self.stageRankingPage = nil
  self.rankingScroll = nil
  self.rankingScrollContent = nil
  self.stageToggles = nil
  self.rankingRewardsBtn = nil
  self.selfPlayerRankingItem = nil
end

local function DataDefine(self)
  self.itemIndex = 0
  self.curPageType = nil
  self.curStageId = nil
  self.prevStageId = nil
  self.actId = nil
  self.hasSentFirstRequest = false
end

local function DataDestroy(self)
  self.itemIndex = nil
  self.curPageType = nil
  self.curStageId = nil
  self.prevStageId = nil
  self.actId = nil
  self.hasSentFirstRequest = nil
end

local function OnSelectStage(self, stageId)
  if self.curPageType ~= LeaderBoardPageType.StageRanking then
    return
  end
  if self.maxStage and self.maxStage ~= -1 and stageId > self.maxStage then
    if self.curStageId then
      self.stageToggles[self.curStageId]:SetIsOn(true)
    end
    return
  end
  self.prevStageId = self.curStageId
  self.curStageId = stageId
  RequstRankingData(self, self.curPageType, self.curStageId)
  for i = 1, 7 do
    if i == stageId then
      self.stageTogglesText[i]:SetColorRGBA(0.164, 0.157, 0.188, 1)
    else
      self.stageTogglesText[i]:SetColorRGBA(0.467, 0.447, 0.443, 1)
    end
  end
end

local function OnSelectPage(self, newPageType)
  if self.curPageType == newPageType then
    return
  end
  self.curPageType = newPageType
  if self.curPageType == LeaderBoardPageType.StageRanking then
    self.stageRankingPage:SetActive(true)
    self.rankingScroll.transform:SetLocalPositionY(38)
    self.rankingScroll.transform:Set_sizeDelta(729, 723)
    self.curStageId = self.prevStageId
    if self.hasSentFirstRequest then
      RequstRankingData(self, self.curPageType, self.prevStageId)
    end
  else
    self.stageRankingPage:SetActive(false)
    self.rankingScroll.transform:SetLocalPositionY(79)
    self.rankingScroll.transform:Set_sizeDelta(729, 804)
    self.prevStageId = self.curStageId
    self.curStageId = -1
    RequstRankingData(self, self.curPageType, nil)
  end
  if self.curPageType == LeaderBoardPageType.StageRanking then
    self.stageRankingToggleText:SetColorRGBA(1, 1, 1, 1)
    self.totalRankingToggleText:SetColorRGBA(0.7529412, 0.7568628, 0.772549, 1)
  else
    self.stageRankingToggleText:SetColorRGBA(0.7529412, 0.7568628, 0.772549, 1)
    self.totalRankingToggleText:SetColorRGBA(1, 1, 1, 1)
  end
end

local function RefreshSelfPlayerInfo(self)
  if not self.playerInfoData then
    return
  end
  self.selfPlayerRankingItem:SetData(self.playerInfoData, true)
end

local function RefreshRankingContent(self, data)
  if not data then
    return
  end
  if self.actId ~= data.actId then
    return
  end
  if self.curPageType == LeaderBoardPageType.StageRanking then
    if self.curStageId ~= data.stageId then
      return
    end
  elseif self.curPageType == LeaderBoardPageType.TotalRanking then
    if data.stageId ~= -1 then
      return
    end
  else
    return
  end
  self.rankingData = DataCenter.StrongestCommanderDataManager:GetRankingData(self.curStageId)
  self.dataList = self.rankingData.playersInfo
  self.playerInfoData = self.rankingData.playerRankingInfo
  ClearScroll(self)
  if self.dataList == nil or #self.dataList == 0 then
    self.rankingScroll:SetActive(false)
    return
  end
  self.rankingScroll:SetActive(true)
  self.rankingScroll:SetListItemCount(#self.dataList, false, false)
  RefreshSelfPlayerInfo(self)
  UnlockPanel(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshRankingData, RefreshRankingContent)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshRankingData, RefreshRankingContent)
end

UIStrComLeaderBoardPanelView.OnCreate = OnCreate
UIStrComLeaderBoardPanelView.OnDestroy = OnDestroy
UIStrComLeaderBoardPanelView.ComponentDefine = ComponentDefine
UIStrComLeaderBoardPanelView.ComponentDestroy = ComponentDestroy
UIStrComLeaderBoardPanelView.DataDefine = DataDefine
UIStrComLeaderBoardPanelView.DataDestroy = DataDestroy
UIStrComLeaderBoardPanelView.OnAddListener = OnAddListener
UIStrComLeaderBoardPanelView.OnRemoveListener = OnRemoveListener
UIStrComLeaderBoardPanelView.OnSelectPage = OnSelectPage
UIStrComLeaderBoardPanelView.OnSelectStage = OnSelectStage
UIStrComLeaderBoardPanelView.LockPanel = LockPanel
UIStrComLeaderBoardPanelView.UnlockPanel = UnlockPanel
return UIStrComLeaderBoardPanelView
