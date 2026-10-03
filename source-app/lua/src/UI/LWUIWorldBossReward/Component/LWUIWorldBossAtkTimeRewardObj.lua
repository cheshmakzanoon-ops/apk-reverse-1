local LWUIWorldBossAtkTimeRewardItem = require("UI.LWUIWorldBossReward.Component.LWUIWorldBossAtkTimeRewardItem")
local LWUIWorldBossAtkTimeRewardObj = BaseClass("LWUIWorldBossAtkTimeRewardObj", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function LWUIWorldBossAtkTimeRewardObj:OnCreate()
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

function LWUIWorldBossAtkTimeRewardObj:OnDestroy()
  base.OnDestroy(self)
end

function LWUIWorldBossAtkTimeRewardObj:OnEnable()
  base.OnEnable(self)
end

function LWUIWorldBossAtkTimeRewardObj:OnDisable()
  base.OnDisable(self)
end

function LWUIWorldBossAtkTimeRewardObj:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(LWUIWorldBossAtkTimeRewardItem)
  self.showDatalist = {}
end

function LWUIWorldBossAtkTimeRewardObj:RefreshList()
  self:ClearScroll()
  self.showDatalist = self.view.ctrl:GetAtkTimeRewardList(self.view.actId)
  self:SetRewardGetFlag()
  if #self.showDatalist > 0 then
    self.ScrollView:SetTotalCount(#self.showDatalist)
    self.ScrollView:RefillCells()
  else
  end
end

function LWUIWorldBossAtkTimeRewardObj:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(LWUIWorldBossAtkTimeRewardItem, itemObj)
  cellItem:SetData(self.showDatalist[index])
end

function LWUIWorldBossAtkTimeRewardObj:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, LWUIWorldBossAtkTimeRewardItem)
end

function LWUIWorldBossAtkTimeRewardObj:SetRewardGetFlag()
  if #self.showDatalist > 0 then
    local attackCount = DataCenter.ActBossDataManager.actBossTransTimes or 0
    for k, v in ipairs(self.showDatalist) do
      local isShowReceFlag = attackCount >= v.times
      for i, reward in ipairs(v.rewards) do
        reward.isShowReceFlag = isShowReceFlag
      end
    end
  end
end

return LWUIWorldBossAtkTimeRewardObj
