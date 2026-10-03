local NewPeakArenaAtkTimeRewardObj = BaseClass("NewPeakArenaAtkTimeRewardObj", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local NewPeakArenaAtkTimeRewardItem = require("UI.NewPeakArenaReward.Component.NewPeakArenaAtkTimeRewardItem")

function NewPeakArenaAtkTimeRewardObj:OnCreate()
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

function NewPeakArenaAtkTimeRewardObj:OnDestroy()
  base.OnDestroy(self)
end

function NewPeakArenaAtkTimeRewardObj:OnEnable()
  base.OnEnable(self)
end

function NewPeakArenaAtkTimeRewardObj:OnDisable()
  base.OnDisable(self)
end

function NewPeakArenaAtkTimeRewardObj:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(NewPeakArenaAtkTimeRewardItem)
  self.showDatalist = {}
end

function NewPeakArenaAtkTimeRewardObj:RefreshList()
  self:ClearScroll()
  self.showDatalist = {}
  local showData
  if self.view.pvpArenaType == PVPArenaType.NewGaleArena then
    showData = DataCenter.NewGaleArenaManager:GetRankRewardData()
  else
    showData = DataCenter.NewPeakArenaManager:GetRankRewardData()
  end
  if showData ~= nil and showData[PVPArenaRewardType.Personal] ~= nil then
    self.showDatalist = showData[PVPArenaRewardType.Personal]
  end
  if #self.showDatalist > 0 then
    self.ScrollView:SetTotalCount(#self.showDatalist)
    self.ScrollView:RefillCells()
  else
  end
end

function NewPeakArenaAtkTimeRewardObj:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(NewPeakArenaAtkTimeRewardItem, itemObj)
  cellItem:SetData(self.showDatalist[index])
end

function NewPeakArenaAtkTimeRewardObj:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, NewPeakArenaAtkTimeRewardItem)
end

return NewPeakArenaAtkTimeRewardObj
