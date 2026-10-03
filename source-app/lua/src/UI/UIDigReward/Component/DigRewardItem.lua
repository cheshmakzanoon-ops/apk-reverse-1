local DigRewardItem = BaseClass("DigRewardItem", UIBaseContainer)
local base = UIBaseContainer
local rewardItem_path = "UICommonResItem"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.rewardItemN = self:AddComponent(UICommonResItem, rewardItem_path)
end

local function ComponentDestroy(self)
  self.rewardItemN = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetItem(self, rewardInfo)
  local tempReward = {}
  tempReward.rewardType = RewardType.GOODS
  tempReward.itemId = rewardInfo.itemId
  tempReward.count = rewardInfo.count
  self.rewardItemN:ReInit(tempReward)
end

DigRewardItem.OnCreate = OnCreate
DigRewardItem.OnDestroy = OnDestroy
DigRewardItem.ComponentDefine = ComponentDefine
DigRewardItem.ComponentDestroy = ComponentDestroy
DigRewardItem.DataDefine = DataDefine
DigRewardItem.DataDestroy = DataDestroy
DigRewardItem.SetItem = SetItem
return DigRewardItem
