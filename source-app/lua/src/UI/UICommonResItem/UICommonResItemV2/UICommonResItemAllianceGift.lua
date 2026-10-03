local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemAllianceGift = BaseClass("UICommonResItemAllianceGift", UICommonResItemBase)
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

local function OnClick(self)
  local desc = ""
  local name = ""
  if self.param.isLocal then
    desc = self.param.itemDesc
    name = self.param.itemName
  else
    desc = CS.GameEntry.Localization:GetString(self.param.itemDesc)
    name = CS.GameEntry.Localization:GetString(self.param.itemName)
  end
  if string.IsNullOrEmpty(desc) and string.IsNullOrEmpty(name) then
    return
  end
  local param = {}
  param.itemName = name
  param.itemDesc = desc
  param.alignObject = self.item_icon
  param.rewardType = self.param.rewardType
  param.itemColor = self.param.itemColor
  param.isLocal = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

UICommonResItemAllianceGift.OnCreate = OnCreate
UICommonResItemAllianceGift.OnDestroy = OnDestroy
UICommonResItemAllianceGift.ComponentDefine = ComponentDefine
UICommonResItemAllianceGift.ComponentDestroy = ComponentDestroy
UICommonResItemAllianceGift.DataDefine = DataDefine
UICommonResItemAllianceGift.DataDestroy = DataDestroy
UICommonResItemAllianceGift.OnClick = OnClick
return UICommonResItemAllianceGift
