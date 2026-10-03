local UICommonResItemGoodsBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemGoodsBase")
local UICommonResItemGoodsDecoratorChoose = BaseClass("UICommonResItemGoodsDecoratorChoose", UICommonResItemGoodsBase)
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
end

local function DataDefine(self)
  base.DataDefine(self)
end

local function DataDestroy(self)
  base.DataDestroy(self)
end

local function OnClick(self)
  if self.param.itemId ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationChoiceBox, {anim = true}, self.param.itemId, true)
  end
end

UICommonResItemGoodsDecoratorChoose.OnCreate = OnCreate
UICommonResItemGoodsDecoratorChoose.OnDestroy = OnDestroy
UICommonResItemGoodsDecoratorChoose.ComponentDefine = ComponentDefine
UICommonResItemGoodsDecoratorChoose.ComponentDestroy = ComponentDestroy
UICommonResItemGoodsDecoratorChoose.DataDefine = DataDefine
UICommonResItemGoodsDecoratorChoose.DataDestroy = DataDestroy
UICommonResItemGoodsDecoratorChoose.OnClick = OnClick
return UICommonResItemGoodsDecoratorChoose
