local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemOtherRewards = BaseClass("UICommonResItemOtherRewards", UICommonResItemBase)
local base = UICommonResItemBase

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
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  base.DataDefine(self)
end

local function DataDestroy(self)
  base.DataDestroy(self)
end

local function OnReInit(self)
  self:SetFlagActive(false)
  if self.param.itemColor then
    self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(self.param.itemColor))
  else
    self:SetItemQualityImage(DataCenter.RewardManager:GetRewardQualityBg(self.param.rewardType, self.param.itemId))
  end
  if self.param.iconName then
    self:SetItemIconImage(self.param.iconName)
  else
    self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType, self.param.itemId, nil, true))
  end
  if self.param.itemName then
    self:SetNameText(self.param.itemName)
  else
    self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId))
  end
end

UICommonResItemOtherRewards.OnCreate = OnCreate
UICommonResItemOtherRewards.OnDestroy = OnDestroy
UICommonResItemOtherRewards.ComponentDefine = ComponentDefine
UICommonResItemOtherRewards.ComponentDestroy = ComponentDestroy
UICommonResItemOtherRewards.DataDefine = DataDefine
UICommonResItemOtherRewards.DataDestroy = DataDestroy
UICommonResItemOtherRewards.OnReInit = OnReInit
return UICommonResItemOtherRewards
