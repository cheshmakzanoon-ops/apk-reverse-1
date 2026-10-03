local UIRevivalPlanRankView = BaseClass("UIRevivalPlanRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LeaderBoardPageType = {
  None = 0,
  StageRanking = 1,
  TotalRanking = 2
}
local UIRevivalPlanRankItemComponent = require("UI.UIActivityRevivalPlan.UIRevivalPlanRank.Component.UIRevivalPlanRankItemComponent")
local stageTogglePath = "Root/Layout/StageToggles/Stage%dToggle"
local stageToggleTextPath = "Root/Layout/StageToggles/Stage%dToggle/StageToggleText%d"
local rankingRewardsBtnPath = "RankingRewardsBtn"

function UIRevivalPlanRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local activityId, stageId, maxStage = self:GetUserData()
  local curStageCfg = DataCenter.ActivityRevivalConfigTemplateManager:GetTemplate(stageId)
  if curStageCfg == nil then
    Logger.LogError("UIRevivalPlanRankView.OnCreate get cur stage cfg invalid !")
    return
  end
  self.curStageIndex = curStageCfg.day_list
  curStageCfg = DataCenter.ActivityRevivalConfigTemplateManager:GetTemplate(maxStage)
  if curStageCfg == nil then
    Logger.LogError("UIRevivalPlanRankView.OnCreate get max stage cfg invalid !")
    return
  end
  self.maxStageIndex = curStageCfg.day_list
  self.actId = activityId
  self.maxStage = maxStage
  if not self.actId then
    self.ctrl:CloseSelf()
    return
  end
  for i = 1, #self.stageToggles do
    local canClick = true
    if self.maxStageIndex and self.maxStageIndex ~= -1 then
      canClick = i <= self.maxStageIndex
    end
    self.stageToggles[i]:SetInteractable(canClick)
  end
  if self.curStageIndex and self.curStageIndex ~= -1 then
    local pageToggleState = self.toggleStageRanking:GetIsOn()
    if not pageToggleState then
      self.toggleStageRanking:SetIsOn(true)
    else
      self:OnSelectPage(LeaderBoardPageType.StageRanking)
    end
    local toggleState = self.stageToggles[self.curStageIndex]:GetIsOn()
    if toggleState then
      self:OnSelectStage(self.curStageIndex)
    else
      self.stageToggles[self.curStageIndex]:SetIsOn(true)
    end
  else
    local pageToggleState = self.toggleTotalRanking:GetIsOn()
    if not pageToggleState then
      self.toggleTotalRanking:SetIsOn(true)
    else
      self:OnSelectPage(LeaderBoardPageType.TotalRanking)
    end
  end
  self:UnlockPanel()
end

function UIRevivalPlanRankView:ClearScroll()
  self.compContent:RemoveComponents(UIRevivalPlanRankItemComponent)
  self.loopListViewRankingScroll:ClearAllItems()
end

function UIRevivalPlanRankView:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIRevivalPlanRankView:LockPanel()
  self.locked = true
  self.toggleStageRanking:SetInteractable(false)
  self.toggleTotalRanking:SetInteractable(false)
  for i = 1, #self.stageToggles do
    self.stageToggles[i]:SetInteractable(false)
  end
  self.rankingRewardsBtn:SetInteractable(false)
end

function UIRevivalPlanRankView:UnlockPanel()
  self.locked = false
  self.toggleStageRanking:SetInteractable(true)
  self.toggleTotalRanking:SetInteractable(true)
  for i = 1, #self.stageToggles do
    local canClick = true
    if self.maxStageIndex and self.maxStageIndex ~= -1 then
      canClick = i <= self.maxStageIndex
    end
    self.stageToggles[i]:SetInteractable(canClick)
  end
  self.rankingRewardsBtn:SetInteractable(true)
end

function UIRevivalPlanRankView:RequestRankingData(pageType, stageId)
  self.hasSentFirstRequest = true
  self:LockPanel()
  if pageType == LeaderBoardPageType.StageRanking then
    local stages = DataCenter.RevivalPlanManager:GetStages(self.actId)
    local stageIndex = table.indexof(stages, stageId)
    if not stageIndex then
      self:UnlockPanel()
      return
    end
    SFSNetwork.SendMessage(MsgDefines.ActivityGetRankInfo, self.actId, 1, 100, stageIndex)
  elseif pageType == LeaderBoardPageType.TotalRanking then
    SFSNetwork.SendMessage(MsgDefines.ActivityGetRankInfo, self.actId, 1, 100, -1)
  end
end

function UIRevivalPlanRankView:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.dataList then
    return nil
  end
  local data = self.dataList[index]
  local item = loopScroll:NewListViewItem("UIRevivalPlanRankItem")
  local script = self.compContent:GetComponent(item.gameObject.name, UIPlayerRankingItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.compContent:AddComponent(UIRevivalPlanRankItemComponent, objectName)
  end
  script:SetActive(true)
  script:SetData(data, false)
  return item
end

function UIRevivalPlanRankView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "Panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.toggleStageRanking = self:AddComponent(UIToggle, "Root/RankingToggles/StageRankingToggle")
  self.textToggleText1 = self:AddComponent(UIText, "Root/RankingToggles/StageRankingToggle/ToggleText1")
  self.toggleTotalRanking = self:AddComponent(UIToggle, "Root/RankingToggles/TotalRankingToggle")
  self.textToggleText2 = self:AddComponent(UIText, "Root/RankingToggles/TotalRankingToggle/ToggleText2")
  self.compStageToggles = self:AddComponent(UIBaseContainer, "Root/Layout/StageToggles")
  self.loopListViewRankingScroll = self:AddComponent(UILoopListView2, "Root/Layout/RankingScroll")
  self.compContent = self:AddComponent(UIBaseContainer, "Root/Layout/RankingScroll/Viewport/Content")
  self.compSelfPlayerItem = self:AddComponent(UIRevivalPlanRankItemComponent, "Root/selfPlayerItem")
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
  self.toggleStageRanking:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnSelectPage(LeaderBoardPageType.StageRanking)
    end
  end)
  self.toggleTotalRanking:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnSelectPage(LeaderBoardPageType.TotalRanking)
    end
  end)
  self.loopListViewRankingScroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.rankingRewardsBtn = self:AddComponent(UIButton, rankingRewardsBtnPath)
  self.rankingRewardsBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRevivalPlanRankReward, {anim = true}, self.actId, self.curStageId, self.maxStage)
  end)
end

function UIRevivalPlanRankView:ComponentDestroy()
  self.btnPanel = nil
  self.btnClose = nil
  self.toggleStageRanking = nil
  self.textToggleText1 = nil
  self.toggleTotalRanking = nil
  self.textToggleText2 = nil
  self.compStageToggles = nil
  self.loopListViewRankingScroll = nil
  self.compContent = nil
  self.btnRankingRewards = nil
  self.compSelfPlayerItem = nil
  self.rankingRewardsBtn = nil
end

function UIRevivalPlanRankView:DataDefine()
  self.itemIndex = 0
  self.curPageType = nil
  self.curStageId = nil
  self.prevStageId = nil
  self.actId = nil
  self.hasSentFirstRequest = false
end

function UIRevivalPlanRankView:DataDestroy()
  self.itemIndex = nil
  self.curPageType = nil
  self.curStageId = nil
  self.prevStageId = nil
  self.actId = nil
  self.hasSentFirstRequest = nil
end

function UIRevivalPlanRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshRankingData, self.RefreshRankingContent)
end

function UIRevivalPlanRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshRankingData, self.RefreshRankingContent)
  base.OnRemoveListener(self)
end

function UIRevivalPlanRankView:OnSelectStage(stageIndex)
  if self.curPageType ~= LeaderBoardPageType.StageRanking then
    return
  end
  local stages = DataCenter.RevivalPlanManager:GetStages(self.actId)
  local stageId = stages[stageIndex]
  if self.curStageId ~= nil and self.curStageId == stageId then
    return
  end
  if self.maxStageIndex and self.maxStageIndex ~= -1 and stageIndex > self.maxStageIndex then
    if self.curStageId then
      local index = table.indexof(stages, self.curStageId)
      local showIndex = index or 1
      self.stageToggles[showIndex]:SetIsOn(true)
    end
    return
  end
  self.prevStageId = self.curStageId
  self.curStageId = stageId
  self:RequestRankingData(self.curPageType, self.curStageId)
  for i = 1, 7 do
    if i == stageIndex then
      self.stageTogglesText[i]:SetColorRGBA(0.164, 0.157, 0.188, 1)
    else
      self.stageTogglesText[i]:SetColorRGBA(0.467, 0.447, 0.443, 1)
    end
  end
end

function UIRevivalPlanRankView:OnSelectPage(newPageType)
  if self.curPageType == newPageType then
    return
  end
  self.curPageType = newPageType
  if self.curPageType == LeaderBoardPageType.StageRanking then
    self.compStageToggles:SetActive(true)
    self.curStageId = self.prevStageId
    if self.hasSentFirstRequest then
      self:RequestRankingData(self.curPageType, self.prevStageId)
    end
  else
    self.compStageToggles:SetActive(false)
    self.prevStageId = self.curStageId
    self.curStageId = -1
    self:RequestRankingData(self.curPageType, nil)
  end
  if self.curPageType == LeaderBoardPageType.StageRanking then
    self.textToggleText1:SetColorRGBA(1, 1, 1, 1)
    self.textToggleText2:SetColorRGBA(0.7529412, 0.7568628, 0.772549, 1)
  else
    self.textToggleText1:SetColorRGBA(0.7529412, 0.7568628, 0.772549, 1)
    self.textToggleText2:SetColorRGBA(1, 1, 1, 1)
  end
end

function UIRevivalPlanRankView:RefreshSelfPlayerInfo()
  if not self.playerInfoData then
    return
  end
  self.compSelfPlayerItem:SetData(self.playerInfoData, true)
end

function UIRevivalPlanRankView:RefreshRankingContent(data)
  if not data then
    return
  end
  if self.actId ~= data.actId then
    return
  end
  if self.curPageType == LeaderBoardPageType.StageRanking then
    local stageIndex = data.stageId
    if not stageIndex then
      return
    end
    local stages = DataCenter.RevivalPlanManager:GetStages(self.actId)
    local stageId = stages[stageIndex]
    if not stageId then
      return
    end
    if self.curStageId ~= stageId then
      return
    end
    self.rankingData = DataCenter.RevivalPlanManager:GetRankingData(stageIndex)
  elseif self.curPageType == LeaderBoardPageType.TotalRanking then
    if data.stageId ~= -1 then
      return
    end
    self.rankingData = DataCenter.RevivalPlanManager:GetRankingData(self.curStageId)
  else
    return
  end
  self.dataList = self.rankingData.playersInfo
  self.playerInfoData = self.rankingData.playerRankingInfo
  self:ClearScroll()
  if self.dataList == nil or #self.dataList == 0 then
    self.loopListViewRankingScroll:SetActive(false)
    self:RefreshSelfPlayerInfo()
    self:UnlockPanel()
    return
  end
  self.loopListViewRankingScroll:SetActive(true)
  self.loopListViewRankingScroll:SetListItemCount(#self.dataList, false, false)
  self:RefreshSelfPlayerInfo()
  self:UnlockPanel()
end

function UIRevivalPlanRankView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIRevivalPlanRankView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return UIRevivalPlanRankView
