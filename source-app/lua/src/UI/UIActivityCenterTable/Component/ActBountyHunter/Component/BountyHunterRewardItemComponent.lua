local BountyHunterRewardItemComponent = BaseClass("BountyHunterRewardItemComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local u_i_common_res_item_path = "UICommonResItem"
local receive_obj_path = "ReceiveObj"
local img_red_path = "Img_Red"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.commonResItem = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.redPoint = self:AddComponent(UIBaseContainer, img_red_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function BountyHunterRewardItemComponent:ReInit(rewardData)
  local rewardParam = {}
  rewardParam.rewardType = rewardData.type
  rewardParam.itemId = rewardData.itemId
  rewardParam.count = rewardData.num
  self.commonResItem:ReInit(rewardParam)
end

BountyHunterRewardItemComponent.OnCreate = OnCreate
BountyHunterRewardItemComponent.OnDestroy = OnDestroy
BountyHunterRewardItemComponent.OnEnable = OnEnable
BountyHunterRewardItemComponent.OnDisable = OnDisable
BountyHunterRewardItemComponent.ComponentDefine = ComponentDefine
BountyHunterRewardItemComponent.ComponentDestroy = ComponentDestroy
BountyHunterRewardItemComponent.DataDefine = DataDefine
BountyHunterRewardItemComponent.DataDestroy = DataDestroy
BountyHunterRewardItemComponent.OnAddListener = OnAddListener
BountyHunterRewardItemComponent.OnRemoveListener = OnRemoveListener
return BountyHunterRewardItemComponent
