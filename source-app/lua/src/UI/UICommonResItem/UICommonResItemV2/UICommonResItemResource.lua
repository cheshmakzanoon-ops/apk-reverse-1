local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemResource = BaseClass("UICommonResItemResource", UICommonResItemBase)
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
  self:SetItemQualityImage(DataCenter.RewardManager:GetRewardQualityBg(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
  self:SetItemIconImage(DataCenter.ResourceManager:GetResourceIconByType(self.param.itemId, true))
end

local function OnClick(self)
  local param = {}
  param.itemId = self.param.itemId
  param.alignObject = self.item_icon
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

UICommonResItemResource.OnCreate = OnCreate
UICommonResItemResource.OnDestroy = OnDestroy
UICommonResItemResource.ComponentDefine = ComponentDefine
UICommonResItemResource.ComponentDestroy = ComponentDestroy
UICommonResItemResource.DataDefine = DataDefine
UICommonResItemResource.DataDestroy = DataDestroy
UICommonResItemResource.OnReInit = OnReInit
UICommonResItemResource.OnClick = OnClick
return UICommonResItemResource
