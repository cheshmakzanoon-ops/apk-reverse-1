local NewPeakArenaAllianceRewardObj = BaseClass("NewPeakArenaAllianceRewardObj", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local NewPeakArenaAllianceRewardItem = require("UI.NewPeakArenaReward.Component.NewPeakArenaAllianceRewardItem")

function NewPeakArenaAllianceRewardObj:OnCreate()
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

function NewPeakArenaAllianceRewardObj:OnDestroy()
  base.OnDestroy(self)
end

function NewPeakArenaAllianceRewardObj:OnEnable()
  base.OnEnable(self)
end

function NewPeakArenaAllianceRewardObj:OnDisable()
  base.OnDisable(self)
end

function NewPeakArenaAllianceRewardObj:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(NewPeakArenaAllianceRewardItem)
  self.showDatalist = {}
end

function NewPeakArenaAllianceRewardObj:RefreshList()
  self:ClearScroll()
  self.showDatalist = {}
  local showData
  if self.view.pvpArenaType == PVPArenaType.NewGaleArena then
    showData = DataCenter.NewGaleArenaManager:GetRankRewardData()
  else
    showData = DataCenter.NewPeakArenaManager:GetRankRewardData()
  end
  if showData ~= nil and showData[PVPArenaRewardType.Rank] ~= nil then
    self.showDatalist = showData[PVPArenaRewardType.Rank]
  end
  if #self.showDatalist > 0 then
    self.ScrollView:SetTotalCount(#self.showDatalist)
    self.ScrollView:RefillCells()
  else
  end
end

function NewPeakArenaAllianceRewardObj:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(NewPeakArenaAllianceRewardItem, itemObj)
  cellItem:SetData(self.showDatalist[index])
end

function NewPeakArenaAllianceRewardObj:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, NewPeakArenaAllianceRewardItem)
end

return NewPeakArenaAllianceRewardObj
