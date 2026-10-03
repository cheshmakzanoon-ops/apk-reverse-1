local LWUIWorldBossRewardItem = require("UI.LWUIWorldBossReward.Component.LWUIWorldBossRewardItem")
local LWUIWorldBossRewardObj = BaseClass("LWUIWorldBossRewardObj", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function LWUIWorldBossRewardObj:OnCreate()
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

function LWUIWorldBossRewardObj:OnDestroy()
  base.OnDestroy(self)
end

function LWUIWorldBossRewardObj:OnEnable()
  base.OnEnable(self)
end

function LWUIWorldBossRewardObj:OnDisable()
  base.OnDisable(self)
end

function LWUIWorldBossRewardObj:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(LWUIWorldBossRewardItem)
  self.showDatalist = {}
end

function LWUIWorldBossRewardObj:RefreshList()
  self:ClearScroll()
  self.showDatalist = self.view.ctrl:GetRankRewardList(self.view.actId)
  if #self.showDatalist > 0 then
    self.ScrollView:SetTotalCount(#self.showDatalist)
    self.ScrollView:RefillCells()
  else
  end
end

function LWUIWorldBossRewardObj:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(LWUIWorldBossRewardItem, itemObj)
  cellItem:SetData(self.showDatalist[index])
end

function LWUIWorldBossRewardObj:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, LWUIWorldBossRewardItem)
end

return LWUIWorldBossRewardObj
