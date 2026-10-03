local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemHeroExp = BaseClass("UICommonResItemHeroExp", UICommonResItemBase)
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
  self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.GREEN))
  self:SetItemIconImage(string.format(LoadPath.CommonNewPath, "Common_icon_hero_exp"))
  self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType))
end

UICommonResItemHeroExp.OnCreate = OnCreate
UICommonResItemHeroExp.OnDestroy = OnDestroy
UICommonResItemHeroExp.ComponentDefine = ComponentDefine
UICommonResItemHeroExp.ComponentDestroy = ComponentDestroy
UICommonResItemHeroExp.DataDefine = DataDefine
UICommonResItemHeroExp.DataDestroy = DataDestroy
UICommonResItemHeroExp.OnReInit = OnReInit
return UICommonResItemHeroExp
