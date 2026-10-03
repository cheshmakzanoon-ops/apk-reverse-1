local base = UIBaseView
local UIStrComRankingRewardPanelView = BaseClass("UIStrComRankingRewardPanelView", base)
local Localization = CS.GameEntry.Localization
local UIRankingRewardItem = require("UI.UIStrComRankingRewardPanel.Component.UIRankingRewardItem")
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
  self.rankingScrollContent:RemoveComponents(UIRankingRewardItem)
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
end

local function RequstRankingRewardData(self, pageType, stageId)
  local rankingRewardData
  rankingRewardData = DataCenter.StrongestCommanderDataManager:GetRankingRewardData(stageId)
  if rankingRewardData then
    self:RefreshRankingReward({
      actId = self.actId,
      stageId = stageId
    })
    return
  end
  if pageType == LeaderBoardPageType.StageRanking then
    SFSNetwork.SendMessage(MsgDefines.ActivityGetRankReward, self.actId, stageId)
  elseif pageType == LeaderBoardPageType.TotalRanking then
    SFSNetwork.SendMessage(MsgDefines.ActivityGetRankReward, self.actId, -1)
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
    if self.curStageId ~= -1 then
      self.stageToggles[self.curStageId]:SetIsOn(true)
    else
      self.stageToggles[1]:SetIsOn(true)
    end
    return
  end
  self.prevStageId = self.curStageId
  self.curStageId = stageId
  RequstRankingRewardData(self, self.curPageType, self.curStageId)
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
    self.rankingScroll.transform:SetLocalPositionY(-83)
    self.rankingScroll.transform:Set_sizeDelta(729, 932)
    self.curStageId = self.prevStageId
    if not self.prevStageId then
      local newStageId = 1
      if self.maxStage == -1 then
        newStageId = 1
      else
        newStageId = self.maxStage
      end
      local pageToggleState = self.stageToggles[newStageId]:GetIsOn()
      if not pageToggleState then
        self.stageRankingToggle:SetIsOn(true)
      else
        self:OnSelectStage(newStageId)
      end
    elseif self.hasSentFirstRequest then
      RequstRankingRewardData(self, self.curPageType, self.prevStageId)
    end
  else
    self.stageRankingPage:SetActive(false)
    self.rankingScroll.transform:SetLocalPositionY(-52.7)
    self.rankingScroll.transform:Set_sizeDelta(729, 993)
    self.prevStageId = self.curStageId
    self.curStageId = -1
    RequstRankingRewardData(self, self.curPageType, -1)
  end
  if self.curPageType == LeaderBoardPageType.StageRanking then
    self.stageRankingToggleText:SetColorRGBA(1, 1, 1, 1)
    self.totalRankingToggleText:SetColorRGBA(0.7529412, 0.7568628, 0.772549, 1)
  else
    self.stageRankingToggleText:SetColorRGBA(0.7529412, 0.7568628, 0.772549, 1)
    self.totalRankingToggleText:SetColorRGBA(1, 1, 1, 1)
  end
end

local function RefreshRankingReward(self, data)
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
  self.dataList = DataCenter.StrongestCommanderDataManager:GetRankingRewardData(self.curStageId)
  ClearScroll(self)
  if self.dataList == nil or #self.dataList == 0 then
    self.rankingScroll:SetActive(false)
    return
  end
  self.rankingScroll:SetActive(true)
  self.rankingScroll:SetListItemCount(#self.dataList, false, false)
  UnlockPanel(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshRankingReward, RefreshRankingReward)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshRankingReward, RefreshRankingReward)
end

UIStrComRankingRewardPanelView.OnCreate = OnCreate
UIStrComRankingRewardPanelView.OnDestroy = OnDestroy
UIStrComRankingRewardPanelView.ComponentDefine = ComponentDefine
UIStrComRankingRewardPanelView.ComponentDestroy = ComponentDestroy
UIStrComRankingRewardPanelView.DataDefine = DataDefine
UIStrComRankingRewardPanelView.DataDestroy = DataDestroy
UIStrComRankingRewardPanelView.OnAddListener = OnAddListener
UIStrComRankingRewardPanelView.OnRemoveListener = OnRemoveListener
UIStrComRankingRewardPanelView.OnSelectPage = OnSelectPage
UIStrComRankingRewardPanelView.OnSelectStage = OnSelectStage
UIStrComRankingRewardPanelView.LockPanel = LockPanel
UIStrComRankingRewardPanelView.UnlockPanel = UnlockPanel
UIStrComRankingRewardPanelView.RefreshRankingReward = RefreshRankingReward
return UIStrComRankingRewardPanelView
