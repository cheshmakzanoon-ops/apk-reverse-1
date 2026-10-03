local LWPVPArenaAtkTimeRewardObj = BaseClass("LWPVPArenaAtkTimeRewardObj", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LWPVPArenaAtkTimeRewardItem = require("UI.LWPVPArena.RewardView.Component.LWPVPArenaAtkTimeRewardItem")

function LWPVPArenaAtkTimeRewardObj:OnCreate()
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

function LWPVPArenaAtkTimeRewardObj:OnDestroy()
  base.OnDestroy(self)
end

function LWPVPArenaAtkTimeRewardObj:OnEnable()
  base.OnEnable(self)
end

function LWPVPArenaAtkTimeRewardObj:OnDisable()
  base.OnDisable(self)
end

function LWPVPArenaAtkTimeRewardObj:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(LWPVPArenaAtkTimeRewardItem)
  self.showDatalist = {}
end

function LWPVPArenaAtkTimeRewardObj:RefreshList()
  self:ClearScroll()
  self.showDatalist = {}
  local showData = DataCenter.LW3V3ArenaManager:GetRankRewardData()
  if showData ~= nil and showData[PVPArenaRewardType.Personal] ~= nil then
    self.showDatalist = showData[PVPArenaRewardType.Personal]
  end
  if #self.showDatalist > 0 then
    self.ScrollView:SetTotalCount(#self.showDatalist)
    self.ScrollView:RefillCells()
  else
  end
end

function LWPVPArenaAtkTimeRewardObj:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(LWPVPArenaAtkTimeRewardItem, itemObj)
  cellItem:SetData(self.showDatalist[index])
end

function LWPVPArenaAtkTimeRewardObj:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, LWPVPArenaAtkTimeRewardItem)
end

return LWPVPArenaAtkTimeRewardObj
