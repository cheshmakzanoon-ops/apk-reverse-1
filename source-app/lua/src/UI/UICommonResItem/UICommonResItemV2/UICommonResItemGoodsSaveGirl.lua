local UICommonResItemGoodsBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemGoodsBase")
local UICommonResItemGoodsSaveGirl = BaseClass("UICommonResItemGoodsSaveGirl", UICommonResItemGoodsBase)
local base = UICommonResItemGoodsBase

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
  if self.eff then
    self.eff:Destroy()
    self.eff = nil
  end
end

local function DataDefine(self)
  base.DataDefine(self)
end

local function DataDestroy(self)
  base.DataDestroy(self)
end

local function OnReInit(self)
  base.OnReInit(self)
end

UICommonResItemGoodsSaveGirl.OnCreate = OnCreate
UICommonResItemGoodsSaveGirl.OnDestroy = OnDestroy
UICommonResItemGoodsSaveGirl.ComponentDefine = ComponentDefine
UICommonResItemGoodsSaveGirl.ComponentDestroy = ComponentDestroy
UICommonResItemGoodsSaveGirl.DataDefine = DataDefine
UICommonResItemGoodsSaveGirl.DataDestroy = DataDestroy
UICommonResItemGoodsSaveGirl.OnReInit = OnReInit
return UICommonResItemGoodsSaveGirl
