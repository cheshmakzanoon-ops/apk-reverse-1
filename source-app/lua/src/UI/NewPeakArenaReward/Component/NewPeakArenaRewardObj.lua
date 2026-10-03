local NewPeakArenaRewardObj = BaseClass("NewPeakArenaRewardObj", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local NewPeakArenaRewardItem = require("UI.NewPeakArenaReward.Component.NewPeakArenaRewardItem")

function NewPeakArenaRewardObj:OnCreate()
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

function NewPeakArenaRewardObj:OnDestroy()
  base.OnDestroy(self)
end

function NewPeakArenaRewardObj:OnEnable()
  base.OnEnable(self)
end

function NewPeakArenaRewardObj:OnDisable()
  base.OnDisable(self)
end

function NewPeakArenaRewardObj:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(NewPeakArenaRewardItem)
  self.showDatalist = {}
end

function NewPeakArenaRewardObj:RefreshList()
  self:ClearScroll()
  self.showDatalist = {}
  local showData
  if self.view.pvpArenaType == PVPArenaType.NewGaleArena then
    showData = DataCenter.NewGaleArenaManager:GetRankRewardData()
  else
    showData = DataCenter.NewPeakArenaManager:GetRankRewardData()
  end
  if showData ~= nil and showData[PVPArenaRewardType.Alliance] ~= nil then
    self.showDatalist = showData[PVPArenaRewardType.Alliance]
  end
  if #self.showDatalist > 0 then
    self.ScrollView:SetTotalCount(#self.showDatalist)
    self.ScrollView:RefillCells()
  else
  end
end

function NewPeakArenaRewardObj:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(NewPeakArenaRewardItem, itemObj)
  cellItem:SetData(self.showDatalist[index])
end

function NewPeakArenaRewardObj:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, NewPeakArenaRewardItem)
end

return NewPeakArenaRewardObj
