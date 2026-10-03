local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemEXP = BaseClass("UICommonResItemEXP", UICommonResItemBase)
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
  self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.BLUE))
  self:SetItemIconImage(string.format(LoadPath.CommonNewPath, "Common_icon_exp"))
  self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType))
end

UICommonResItemEXP.OnCreate = OnCreate
UICommonResItemEXP.OnDestroy = OnDestroy
UICommonResItemEXP.ComponentDefine = ComponentDefine
UICommonResItemEXP.ComponentDestroy = ComponentDestroy
UICommonResItemEXP.DataDefine = DataDefine
UICommonResItemEXP.DataDestroy = DataDestroy
UICommonResItemEXP.OnReInit = OnReInit
return UICommonResItemEXP
