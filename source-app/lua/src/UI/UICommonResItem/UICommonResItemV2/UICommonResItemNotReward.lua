local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemNotReward = BaseClass("UICommonResItemNotReward", UICommonResItemBase)
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
  self.item_bg:SetActive(false)
  self.item_quality:SetActive(false)
  self.hero_quality:SetActive(false)
  self:SetFlagActive(false)
  self:SetItemIconImage(string.format(LoadPath.CommonNewPath, self.param.itemIcon))
end

UICommonResItemNotReward.OnCreate = OnCreate
UICommonResItemNotReward.OnDestroy = OnDestroy
UICommonResItemNotReward.ComponentDefine = ComponentDefine
UICommonResItemNotReward.ComponentDestroy = ComponentDestroy
UICommonResItemNotReward.DataDefine = DataDefine
UICommonResItemNotReward.DataDestroy = DataDestroy
UICommonResItemNotReward.OnReInit = OnReInit
return UICommonResItemNotReward
