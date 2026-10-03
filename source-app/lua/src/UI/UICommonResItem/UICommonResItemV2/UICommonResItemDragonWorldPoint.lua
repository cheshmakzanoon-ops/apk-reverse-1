local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemDragonWorldPoint = BaseClass("UICommonResItemDragonWorldPoint", UICommonResItemBase)
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
  self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType))
  self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.ORANGE))
  self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType))
end

UICommonResItemDragonWorldPoint.OnCreate = OnCreate
UICommonResItemDragonWorldPoint.OnDestroy = OnDestroy
UICommonResItemDragonWorldPoint.ComponentDefine = ComponentDefine
UICommonResItemDragonWorldPoint.ComponentDestroy = ComponentDestroy
UICommonResItemDragonWorldPoint.DataDefine = DataDefine
UICommonResItemDragonWorldPoint.DataDestroy = DataDestroy
UICommonResItemDragonWorldPoint.OnReInit = OnReInit
return UICommonResItemDragonWorldPoint
