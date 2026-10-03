local UISeasonTowerRankRewardObj = BaseClass("UISeasonTowerRankRewardObj", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UISeasonTowerRankRewardItem = require("UI.LWUISeasonTower.UISeasonTowerRankReward.Component.UISeasonTowerRankRewardItem")

function UISeasonTowerRankRewardObj:OnCreate()
  base.OnCreate(self)
  self.showDatalist = {}
  self.ScrollView = self:AddComponent(UIScrollView, "")
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function UISeasonTowerRankRewardObj:OnDestroy()
  base.OnDestroy(self)
end

function UISeasonTowerRankRewardObj:OnEnable()
  base.OnEnable(self)
end

function UISeasonTowerRankRewardObj:OnDisable()
  base.OnDisable(self)
end

function UISeasonTowerRankRewardObj:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(UISeasonTowerRankRewardItem)
  self.showDatalist = {}
end

function UISeasonTowerRankRewardObj:RefreshList()
  self:ClearScroll()
  self.showDatalist = DataCenter.LWSeasonTowerManager:GetCurrentRankRewardShowList()
  if #self.showDatalist > 0 then
    self.ScrollView:SetTotalCount(#self.showDatalist)
    self.ScrollView:RefillCells()
  else
  end
end

function UISeasonTowerRankRewardObj:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UISeasonTowerRankRewardItem, itemObj)
  cellItem:SetData(self.showDatalist[index])
end

function UISeasonTowerRankRewardObj:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UISeasonTowerRankRewardItem)
end

return UISeasonTowerRankRewardObj
