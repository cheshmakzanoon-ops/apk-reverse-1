local base = UIBaseView
local LWUIAllyDuelRewardPanelView = BaseClass("LWUIAllyDuelRewardPanelView", base)
local CLS = {
  "UI.LWUIAllyDuel.LWUIAllyDuelRewardPanel.Component.UIAllyDuelRewardPersonalSubPanel",
  "UI.LWUIAllyDuel.LWUIAllyDuelRewardPanel.Component.UIAllyDuelRewardAllySubPanel",
  "UI.LWUIAllyDuel.LWUIAllyDuelRewardPanel.Component.UIAllyDuelRewardLeagueSubPanel"
}
local PREFAB = {
  "UIAllyDuelRewardPersonalSubPanel",
  "UIAllyDuelRewardAllySubPanel",
  "UIAllyDuelRewardLeagueSubPanel"
}
local PREFAB_PATH = "Assets/Main/Prefabs/UI/UIAllyDuel/%s.prefab"
local TabType = {
  DayReward = 1,
  AlReward = 2,
  SeasonReward = 3
}
local TabName = {
  [TabType.DayReward] = "372815",
  [TabType.AlReward] = "372816",
  [TabType.SeasonReward] = "372817"
}
local TitleName = {
  [TabType.DayReward] = "372637",
  [TabType.AlReward] = "372638",
  [TabType.SeasonReward] = "372639"
}
local SegmentName = {
  [SegmentType.Silver] = "372611",
  [SegmentType.Gold] = "372612",
  [SegmentType.Diamond] = "372613"
}
local panel_path = "panel"
local title_path = "bg/topBar/TextTitle"
local closeBtn_path = "bg/topBar/BtnClose"
local tab_path = "bg/main/tabSv/Content/AllyDuelTab"
local segmentContainer_path = "bg/main/down/ToggleGroup"
local segment_path = "bg/main/down/ToggleGroup/Toggle"
local content_path = "bg/main/down/content"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.tabTbN = {}
  for i = 1, 3 do
    local tab = self:AddComponent(UIButton, tab_path .. i)
    tab:SetOnClick(function()
      self:OnClickTab(i)
    end)
    local select = tab:AddComponent(UIBaseContainer, "Select")
    local selectTxt = tab:AddComponent(UIText, "Select/SelectText")
    selectTxt:SetLocalText(TabName[i])
    local unselectTxt = tab:AddComponent(UIText, "Unselect/UnSelectText")
    unselectTxt:SetLocalText(TabName[i])
    local red = tab:AddComponent(UIBaseContainer, "RedDot")
    red:SetActive(false)
    local visible = self:CheckIfTabVisible(i)
    tab:SetActive(visible)
    local newTab = {
      rootN = tab,
      btnN = tab,
      selectN = select,
      selectTxtN = selectTxt,
      unselectTxtN = unselectTxt,
      redN = red,
      isVisible = visible
    }
    table.insert(self.tabTbN, newTab)
  end
  self.segmentN = self:AddComponent(UIBaseContainer, segmentContainer_path)
  self.segmentN:SetActive(DataCenter.LeagueMatchManager:CheckIsOpenForReward())
  self.segmentTbN = {}
  for i = 1, 3 do
    local segment = self:AddComponent(UIBaseContainer, segment_path .. i)
    local btn = segment:AddComponent(UIButton, "")
    btn:SetOnClick(function()
      self:OnClickSegment(i)
    end)
    local select = segment:AddComponent(UIBaseContainer, "select")
    local selectTxt = segment:AddComponent(UIText, "select/selectText")
    selectTxt:SetLocalText(SegmentName[i])
    local unselectTxt = segment:AddComponent(UIText, "unselectText")
    unselectTxt:SetLocalText(SegmentName[i])
    local red = segment:AddComponent(UIBaseContainer, "RedDot1")
    local you = segment:AddComponent(UIBaseContainer, "youDot")
    local newSeg = {
      selectN = select,
      selectTxtN = selectTxt,
      unselectTxtN = unselectTxt,
      redN = red,
      youN = you,
      btnN = btn
    }
    table.insert(self.segmentTbN, newSeg)
  end
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.panelTbN = {}
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.tabTbN = nil
  self.segmentN = nil
  self.segmentTbN = nil
  self.panelTbN = nil
end

local function DataDefine(self)
  self.curTab = 1
  self.curSegment = SegmentType.None
  self.cacheSeg = SegmentType.None
end

local function DataDestroy(self)
  self.curTab = 1
  self.curSegment = nil
  self.cacheSeg = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function InitUI(self)
  self.isInMatch = DataCenter.LeagueMatchManager:CheckIsMatchOpen()
  local targetTab, targetSeg = self:GetUserData()
  if not self.tabTbN[targetTab] or not self.tabTbN[targetTab].isVisible then
    for i, v in ipairs(self.tabTbN) do
      if v.isVisible then
        targetTab = i
        break
      end
    end
  end
  if self.isInMatch then
    targetSeg = targetSeg or SegmentType.Silver
  else
    targetSeg = SegmentType.None
  end
  self.cacheSeg = targetSeg
  self:SelectTabAndSegment(targetTab, targetSeg)
  local duelInfo = DataCenter.LeagueMatchManager:GetMyCurDuelInfo()
  local myRankType = 0
  if duelInfo and duelInfo.rankType then
    myRankType = duelInfo.rankType
  end
  for i, v in ipairs(self.segmentTbN) do
    if i == myRankType then
      v.youN:SetActive(true)
    else
      v.youN:SetActive(false)
    end
  end
end

local function SelectTabAndSegment(self, tab, seg)
  if self.curTab == tab and self.curSegment == seg then
    return
  end
  self.curTab = tab
  self.curSegment = seg
  for i, v in ipairs(self.tabTbN) do
    if i == tab then
      v.selectN:SetActive(true)
    else
      v.selectN:SetActive(false)
    end
  end
  for i, v in ipairs(self.segmentTbN) do
    if i == seg then
      v.selectN:SetActive(true)
    else
      v.selectN:SetActive(false)
    end
  end
  self.titleN:SetLocalText(TitleName[tab])
  self:ShowPanel(tab)
end

local function CheckIfTabVisible(self, tab)
  if tab == TabType.SeasonReward then
    return DataCenter.LeagueMatchManager:CheckIsOpenForReward()
  else
    return true
  end
end

local function CheckIfInMatch(self)
  return DataCenter.LeagueMatchManager:CheckIfInMatch()
end

local function OnClickCloseBtn(self)
  self.ctrl:CloseSelf()
end

local function OnClickTab(self, index)
  self:SelectTabAndSegment(index, self.cacheSeg)
end

local function OnClickSegment(self, index)
  self:SelectTabAndSegment(self.curTab, index)
end

function LWUIAllyDuelRewardPanelView:ShowPanel(tab)
  if self.curPanel then
    self.curPanel:SetActive(false)
  end
  self.curPanel = self.panelTbN[tab]
  if self.curPanel then
    if self.curPanel:AsyncLoadDone() then
      self.curPanel:SetActive(true)
      self.curPanel:ShowPanel(self.curSegment)
    end
    return
  end
  local cls = CLS[tab]
  local prefab = string.format(PREFAB_PATH, PREFAB[tab])
  local panel = self:LoadComponentAsync(cls, prefab, self.content, function()
    if tab ~= self.curTab then
      return
    end
    local curPanel = self.panelTbN[tab]
    curPanel:SetOffsetMaxXY(0, 0)
    curPanel:SetOffsetMinXY(0, 0)
    curPanel:SetActive(true)
    curPanel:ShowPanel(self.curSegment)
  end)
  self.panelTbN[tab] = panel
  self.curPanel = panel
end

LWUIAllyDuelRewardPanelView.OnCreate = OnCreate
LWUIAllyDuelRewardPanelView.OnDestroy = OnDestroy
LWUIAllyDuelRewardPanelView.OnAddListener = OnAddListener
LWUIAllyDuelRewardPanelView.OnRemoveListener = OnRemoveListener
LWUIAllyDuelRewardPanelView.ComponentDefine = ComponentDefine
LWUIAllyDuelRewardPanelView.ComponentDestroy = ComponentDestroy
LWUIAllyDuelRewardPanelView.DataDefine = DataDefine
LWUIAllyDuelRewardPanelView.DataDestroy = DataDestroy
LWUIAllyDuelRewardPanelView.InitUI = InitUI
LWUIAllyDuelRewardPanelView.SelectTabAndSegment = SelectTabAndSegment
LWUIAllyDuelRewardPanelView.CheckIfTabVisible = CheckIfTabVisible
LWUIAllyDuelRewardPanelView.CheckIfInMatch = CheckIfInMatch
LWUIAllyDuelRewardPanelView.OnClickCloseBtn = OnClickCloseBtn
LWUIAllyDuelRewardPanelView.OnClickTab = OnClickTab
LWUIAllyDuelRewardPanelView.OnClickSegment = OnClickSegment
return LWUIAllyDuelRewardPanelView
