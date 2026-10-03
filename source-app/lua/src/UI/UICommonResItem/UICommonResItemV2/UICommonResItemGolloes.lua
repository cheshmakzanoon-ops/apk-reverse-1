local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemGolloes = BaseClass("UICommonResItemGolloes", UICommonResItemBase)
local base = UICommonResItemBase
local Localization = CS.GameEntry.Localization

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
  self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
  self:SetItemIconImage(string.format("Assets/Main/Sprites/UI/UIGolloesCamp/%s", GolloesShow[self.param.itemId].rewardIcon))
  self:SetNameText(Localization:GetString(GolloesShow[self.param.itemId].name))
end

UICommonResItemGolloes.OnCreate = OnCreate
UICommonResItemGolloes.OnDestroy = OnDestroy
UICommonResItemGolloes.ComponentDefine = ComponentDefine
UICommonResItemGolloes.ComponentDestroy = ComponentDestroy
UICommonResItemGolloes.DataDefine = DataDefine
UICommonResItemGolloes.DataDestroy = DataDestroy
UICommonResItemGolloes.OnReInit = OnReInit
return UICommonResItemGolloes
