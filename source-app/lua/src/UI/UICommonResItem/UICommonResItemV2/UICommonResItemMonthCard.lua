local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemMonthCard = BaseClass("UICommonResItemMonthCard", UICommonResItemBase)
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
  self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
  self:SetItemIconImage("Assets/Main/Sprites/GiftPackageIcons/lyp_yueka_xuanzhong.png")
end

UICommonResItemMonthCard.OnCreate = OnCreate
UICommonResItemMonthCard.OnDestroy = OnDestroy
UICommonResItemMonthCard.ComponentDefine = ComponentDefine
UICommonResItemMonthCard.ComponentDestroy = ComponentDestroy
UICommonResItemMonthCard.DataDefine = DataDefine
UICommonResItemMonthCard.DataDestroy = DataDestroy
UICommonResItemMonthCard.OnReInit = OnReInit
return UICommonResItemMonthCard
