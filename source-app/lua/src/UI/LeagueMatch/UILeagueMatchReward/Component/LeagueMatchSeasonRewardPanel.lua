local LeagueMatchSeasonRewardPanel = BaseClass("LeagueMatchSeasonRewardPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LeagueMatchSeasonRewardItem = require("UI.LeagueMatch.UILeagueMatchReward.Component.LeagueMatchSeasonRewardItem")
local scrollView_path = "ScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.scrollViewN = self:AddComponent(UIScrollView, scrollView_path)
  self.scrollViewN:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollViewN:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.scrollViewN = nil
end

local function DataDefine(self)
  self.rewardInfo = nil
  self.curSegment = nil
end

local function DataDestroy(self)
  self.rewardInfo = nil
  self.curSegment = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnLeagueMatchRewardInfoUpdate, self.RefreshAll)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnLeagueMatchRewardInfoUpdate, self.RefreshAll)
end

local function ShowPanel(self, segment)
  self.curSegment = segment
  self:RefreshAll()
end

local function RefreshAll(self)
  self.rewardInfo = DataCenter.LeagueMatchManager:GetRewardInfo(3, self.curSegment)
  if not self.rewardInfo then
    return
  else
    self.scrollViewN:SetTotalCount(#self.rewardInfo)
    self.scrollViewN:RefillCells()
  end
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewN:AddComponent(LeagueMatchSeasonRewardItem, itemObj)
  cellItem:SetItem(self.rewardInfo[index])
end

local function OnItemMoveOut(self, itemObj, index)
  self.scrollViewN:RemoveComponent(itemObj.name, LeagueMatchSeasonRewardItem)
end

local function ClearScroll(self)
  self.scrollViewN:ClearCells()
  self.scrollViewN:RemoveComponents(LeagueMatchSeasonRewardItem)
end

LeagueMatchSeasonRewardPanel.OnCreate = OnCreate
LeagueMatchSeasonRewardPanel.OnDestroy = OnDestroy
LeagueMatchSeasonRewardPanel.ComponentDefine = ComponentDefine
LeagueMatchSeasonRewardPanel.ComponentDestroy = ComponentDestroy
LeagueMatchSeasonRewardPanel.DataDefine = DataDefine
LeagueMatchSeasonRewardPanel.DataDestroy = DataDestroy
LeagueMatchSeasonRewardPanel.OnAddListener = OnAddListener
LeagueMatchSeasonRewardPanel.OnRemoveListener = OnRemoveListener
LeagueMatchSeasonRewardPanel.ShowPanel = ShowPanel
LeagueMatchSeasonRewardPanel.RefreshAll = RefreshAll
LeagueMatchSeasonRewardPanel.OnItemMoveIn = OnItemMoveIn
LeagueMatchSeasonRewardPanel.OnItemMoveOut = OnItemMoveOut
LeagueMatchSeasonRewardPanel.ClearScroll = ClearScroll
return LeagueMatchSeasonRewardPanel
