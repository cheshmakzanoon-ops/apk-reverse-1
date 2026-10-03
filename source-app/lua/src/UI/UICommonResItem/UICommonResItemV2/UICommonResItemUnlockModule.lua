local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemUnlockModule = BaseClass("UICommonResItemUnlockModule", UICommonResItemBase)
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
  self.item_bg:SetActive(false)
  self.item_quality:SetActive(false)
  self.hero_quality:SetActive(false)
  self:SetItemIconImage(string.format(LoadPath.CommonNewPath, self.param.itemIcon))
end

UICommonResItemUnlockModule.OnCreate = OnCreate
UICommonResItemUnlockModule.OnDestroy = OnDestroy
UICommonResItemUnlockModule.ComponentDefine = ComponentDefine
UICommonResItemUnlockModule.ComponentDestroy = ComponentDestroy
UICommonResItemUnlockModule.DataDefine = DataDefine
UICommonResItemUnlockModule.DataDestroy = DataDestroy
UICommonResItemUnlockModule.OnReInit = OnReInit
return UICommonResItemUnlockModule
