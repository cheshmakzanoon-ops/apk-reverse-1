local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemCommonEquip = BaseClass("UICommonResItemCommonEquip", UICommonResItemBase)
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
  self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
  self:SetItemQualityImage(DataCenter.RewardManager:GetRewardQualityBg(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
  self:SetNameText(DataCenter.RewardManager:GetNameByType(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
  local flagText = DataCenter.RewardManager:GetFlagText(RewardType.CommonEquip, self.param.itemId)
  if string.IsNullOrEmpty(flagText) then
    self:SetFlagActive(false)
  else
    self:SetFlagActive(true)
    self:SetFlagText(flagText)
  end
end

UICommonResItemCommonEquip.OnCreate = OnCreate
UICommonResItemCommonEquip.OnDestroy = OnDestroy
UICommonResItemCommonEquip.ComponentDefine = ComponentDefine
UICommonResItemCommonEquip.ComponentDestroy = ComponentDestroy
UICommonResItemCommonEquip.DataDefine = DataDefine
UICommonResItemCommonEquip.DataDestroy = DataDestroy
UICommonResItemCommonEquip.OnReInit = OnReInit
return UICommonResItemCommonEquip
