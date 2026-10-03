local base = UIBaseContainer
local LWUIZombieRushRewardItemRender = BaseClass("LWUIZombieRushRewardItemRender", base)
local numText_path = "NumText"
local rewardScrollView_path = "RewardScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearRewardScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.numText = self:AddComponent(UITextMeshProUGUIEx, numText_path)
  self.rewardScrollView = self:AddComponent(UIScrollView, rewardScrollView_path)
  self.rewardScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:RewardItemMoveIn(itemObj, index)
  end)
  self.rewardScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:RewardItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.numText = nil
  self.rewardScrollView = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, rewardList, targetValue)
  self.numText:SetText(targetValue)
  self.rewardList = rewardList
  local rewardCount = table.count(rewardList)
  if 0 < rewardCount then
    self.rewardScrollView:SetTotalCount(rewardCount)
    self.rewardScrollView:RefillCells()
  end
end

local function RewardItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.rewardScrollView:AddComponent(UICommonResItem, itemObj)
  itemRender:SetLocalScaleXYZ(0.73, 0.73, 1)
  itemRender:ReInit(self.rewardList[index])
end

local function RewardItemMoveOut(self, itemObj, index)
  self.rewardScrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

local function ClearRewardScroll(self)
  self.rewardScrollView:ClearCells()
  self.rewardScrollView:RemoveComponents(UICommonResItem)
end

LWUIZombieRushRewardItemRender.OnCreate = OnCreate
LWUIZombieRushRewardItemRender.OnDestroy = OnDestroy
LWUIZombieRushRewardItemRender.OnEnable = OnEnable
LWUIZombieRushRewardItemRender.OnDisable = OnDisable
LWUIZombieRushRewardItemRender.ComponentDefine = ComponentDefine
LWUIZombieRushRewardItemRender.ComponentDestroy = ComponentDestroy
LWUIZombieRushRewardItemRender.DataDefine = DataDefine
LWUIZombieRushRewardItemRender.DataDestroy = DataDestroy
LWUIZombieRushRewardItemRender.SetData = SetData
LWUIZombieRushRewardItemRender.RewardItemMoveIn = RewardItemMoveIn
LWUIZombieRushRewardItemRender.RewardItemMoveOut = RewardItemMoveOut
LWUIZombieRushRewardItemRender.ClearRewardScroll = ClearRewardScroll
return LWUIZombieRushRewardItemRender
