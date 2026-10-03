local base = UIBaseContainer
local RankScrollViewComponent = BaseClass("RankScrollViewComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local RewardItem = require("UI.UIGhostParkour.Outside.TypeRankReward.Component.GhostParkourRankRewardItem")

function RankScrollViewComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RankScrollViewComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RankScrollViewComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.ScrollView = self.viewSkin:AddComponent(self, UIScrollView, 1)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function RankScrollViewComponent:ComponentDestroy()
  self.viewSkin = nil
  self.ScrollView = nil
end

function RankScrollViewComponent:DataDefine()
  self.showDatalist = {}
end

function RankScrollViewComponent:DataDestroy()
  self:ClearScroll()
  self.showDatalist = nil
end

function RankScrollViewComponent:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(RewardItem)
  self.showDatalist = {}
end

function RankScrollViewComponent:OnAddListener()
  base.OnAddListener(self)
end

function RankScrollViewComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function RankScrollViewComponent:RefreshList(type)
  self:ClearScroll()
  self.showDatalist = {}
  self.round = DataCenter.LWGhostParkourDataManager:GetGhostParkourRound()
  local showData = DataCenter.LWGhostParkourDataManager:GetTypeRankRewardInfo(self.round, type)
  if showData ~= nil then
    self.showDatalist = showData
  end
  if #self.showDatalist > 0 then
    self.ScrollView:SetTotalCount(#self.showDatalist)
    self.ScrollView:RefillCells()
  end
end

function RankScrollViewComponent:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(RewardItem, itemObj)
  cellItem:SetData(self.showDatalist[index], index)
end

function RankScrollViewComponent:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, RewardItem)
end

return RankScrollViewComponent
