local UILWInfiniteGiftRewardItem = BaseClass("UILWInfiniteGiftRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rewardItem_path = "UICommonResItem"
local effect_path = "Effect"

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

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.rewardItem = self:AddComponent(UICommonResItem, rewardItem_path)
  self.effect = self:AddComponent(UIBaseContainer, effect_path)
end

local function ComponentDestroy(self)
  self.rewardItem = nil
  self.effect = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function ReInit(self, data)
  self.data = data
  if self.data == nil then
    return
  end
  self.rewardItem:ReInit(data)
  local showEffect = false
  if data.rewardType == RewardType.GOODS then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(data.itemId)
    if goods and goods.color == ItemColor.ORANGE then
      showEffect = true
    end
  end
  self.effect:SetActive(showEffect)
end

UILWInfiniteGiftRewardItem.OnCreate = OnCreate
UILWInfiniteGiftRewardItem.OnDestroy = OnDestroy
UILWInfiniteGiftRewardItem.OnAddListener = OnAddListener
UILWInfiniteGiftRewardItem.OnRemoveListener = OnRemoveListener
UILWInfiniteGiftRewardItem.OnEnable = OnEnable
UILWInfiniteGiftRewardItem.OnDisable = OnDisable
UILWInfiniteGiftRewardItem.ComponentDefine = ComponentDefine
UILWInfiniteGiftRewardItem.ComponentDestroy = ComponentDestroy
UILWInfiniteGiftRewardItem.DataDefine = DataDefine
UILWInfiniteGiftRewardItem.DataDestroy = DataDestroy
UILWInfiniteGiftRewardItem.ReInit = ReInit
return UILWInfiniteGiftRewardItem
