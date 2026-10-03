local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemActGiftBox = BaseClass("UICommonResItemActGiftBox", UICommonResItemBase)
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
  local template = DataCenter.ActGiftBoxData:GetActBoxInfoByItemId(self.param.itemId)
  self:SetFlagActive(false)
  self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(self:ConvertGiftBoxQuality(toInt(template.quality))))
  self:SetItemIconImage(string.format(LoadPath.UImystery, template.reward_icon))
  self:SetNameText(CS.GameEntry.Localization:GetString(template.reward_name))
  self:SetItemCountActive(false)
end

UICommonResItemActGiftBox.OnCreate = OnCreate
UICommonResItemActGiftBox.OnDestroy = OnDestroy
UICommonResItemActGiftBox.ComponentDefine = ComponentDefine
UICommonResItemActGiftBox.ComponentDestroy = ComponentDestroy
UICommonResItemActGiftBox.DataDefine = DataDefine
UICommonResItemActGiftBox.DataDestroy = DataDestroy
UICommonResItemActGiftBox.OnReInit = OnReInit
return UICommonResItemActGiftBox
