local LWPVPArenaAllianceRewardObj = BaseClass("LWPVPArenaAllianceRewardObj", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LWPVPArenaAllianceRewardItem = require("UI.LWPVPArena.RewardView.Component.LWPVPArenaAllianceRewardItem")

function LWPVPArenaAllianceRewardObj:OnCreate()
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

function LWPVPArenaAllianceRewardObj:OnDestroy()
  base.OnDestroy(self)
end

function LWPVPArenaAllianceRewardObj:OnEnable()
  base.OnEnable(self)
end

function LWPVPArenaAllianceRewardObj:OnDisable()
  base.OnDisable(self)
end

function LWPVPArenaAllianceRewardObj:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(LWPVPArenaAllianceRewardItem)
  self.showDatalist = {}
end

function LWPVPArenaAllianceRewardObj:RefreshList()
  self:ClearScroll()
  self.showDatalist = {}
  local showData = DataCenter.LW3V3ArenaManager:GetRankRewardData()
  if showData ~= nil and showData[PVPArenaRewardType.Rank] ~= nil then
    self.showDatalist = showData[PVPArenaRewardType.Rank]
  end
  if #self.showDatalist > 0 then
    self.ScrollView:SetTotalCount(#self.showDatalist)
    self.ScrollView:RefillCells()
  else
  end
end

function LWPVPArenaAllianceRewardObj:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(LWPVPArenaAllianceRewardItem, itemObj)
  cellItem:SetData(self.showDatalist[index])
end

function LWPVPArenaAllianceRewardObj:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, LWPVPArenaAllianceRewardItem)
end

return LWPVPArenaAllianceRewardObj
