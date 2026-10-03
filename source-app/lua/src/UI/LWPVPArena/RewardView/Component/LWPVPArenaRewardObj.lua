local LWPVPArenaRewardObj = BaseClass("LWPVPArenaRewardObj", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LWPVPArenaRewardItem = require("UI.LWPVPArena.RewardView.Component.LWPVPArenaRewardItem")

function LWPVPArenaRewardObj:OnCreate()
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

function LWPVPArenaRewardObj:OnDestroy()
  base.OnDestroy(self)
end

function LWPVPArenaRewardObj:OnEnable()
  base.OnEnable(self)
end

function LWPVPArenaRewardObj:OnDisable()
  base.OnDisable(self)
end

function LWPVPArenaRewardObj:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(LWPVPArenaRewardItem)
  self.showDatalist = {}
end

function LWPVPArenaRewardObj:RefreshList()
  self:ClearScroll()
  self.showDatalist = {}
  local showData = DataCenter.LW3V3ArenaManager:GetRankRewardData()
  if showData ~= nil and showData[PVPArenaRewardType.Alliance] ~= nil then
    self.showDatalist = showData[PVPArenaRewardType.Alliance]
  end
  if #self.showDatalist > 0 then
    self.ScrollView:SetTotalCount(#self.showDatalist)
    self.ScrollView:RefillCells()
  else
  end
end

function LWPVPArenaRewardObj:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(LWPVPArenaRewardItem, itemObj)
  cellItem:SetData(self.showDatalist[index])
end

function LWPVPArenaRewardObj:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, LWPVPArenaRewardItem)
end

return LWPVPArenaRewardObj
