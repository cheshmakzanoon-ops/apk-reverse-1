local LWUIWorldBossRewardItem = require("UI.LWUIWorldBossReward.Component.LWUIWorldBossRewardItem")
local LWUIMonsterInvasionRewardObj = BaseClass("LWUIMonsterInvasionRewardObj", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function LWUIMonsterInvasionRewardObj:OnCreate()
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

function LWUIMonsterInvasionRewardObj:OnDestroy()
  base.OnDestroy(self)
end

function LWUIMonsterInvasionRewardObj:OnEnable()
  base.OnEnable(self)
end

function LWUIMonsterInvasionRewardObj:OnDisable()
  base.OnDisable(self)
end

function LWUIMonsterInvasionRewardObj:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(LWUIWorldBossRewardItem)
  self.showDatalist = {}
end

function LWUIMonsterInvasionRewardObj:RefreshList(actId)
  self.actId = actId
  self:ClearScroll()
  self.showDatalist = self.view.ctrl:GetRankRewardList(self.view.actId)
  if #self.showDatalist > 0 then
    self.ScrollView:SetTotalCount(#self.showDatalist)
    self.ScrollView:RefillCells()
  else
    SFSNetwork.SendMessage(MsgDefines.ActivityGetRankReward, self.actId, -1)
  end
end

function LWUIMonsterInvasionRewardObj:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(LWUIWorldBossRewardItem, itemObj)
  cellItem:SetData(self.showDatalist[index])
end

function LWUIMonsterInvasionRewardObj:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, LWUIWorldBossRewardItem)
end

return LWUIMonsterInvasionRewardObj
