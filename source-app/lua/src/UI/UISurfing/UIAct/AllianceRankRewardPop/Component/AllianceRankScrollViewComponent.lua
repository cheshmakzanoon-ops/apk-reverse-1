local base = UIBaseContainer
local AllianceRankScrollViewComponent = BaseClass("AllianceRankScrollViewComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local AllianceRewardItem = require("UI.UISurfing.UIAct.AllianceRankRewardPop.Component.AllianceRewardItem")

function AllianceRankScrollViewComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllianceRankScrollViewComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllianceRankScrollViewComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.ScrollView = self.viewSkin:AddComponent(self, UIScrollView, 1)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function AllianceRankScrollViewComponent:ComponentDestroy()
  self.viewSkin = nil
  self.ScrollView = nil
end

function AllianceRankScrollViewComponent:DataDefine()
  self.showDatalist = {}
end

function AllianceRankScrollViewComponent:DataDestroy()
  self:ClearScroll()
  self.showDatalist = nil
end

function AllianceRankScrollViewComponent:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(AllianceRewardItem)
  self.showDatalist = {}
end

function AllianceRankScrollViewComponent:OnAddListener()
  base.OnAddListener(self)
end

function AllianceRankScrollViewComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllianceRankScrollViewComponent:RefreshList(type)
  self:ClearScroll()
  self.showDatalist = {}
  local showData = DataCenter.LWSurfingDataManager:GetRankRewardInfos(type)
  if showData ~= nil then
    self.showDatalist = showData
  end
  if #self.showDatalist > 0 then
    self.ScrollView:SetTotalCount(#self.showDatalist)
    self.ScrollView:RefillCells()
  else
  end
end

function AllianceRankScrollViewComponent:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(AllianceRewardItem, itemObj)
  cellItem:SetData(self.showDatalist[index], index)
end

function AllianceRankScrollViewComponent:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, AllianceRewardItem)
end

return AllianceRankScrollViewComponent
