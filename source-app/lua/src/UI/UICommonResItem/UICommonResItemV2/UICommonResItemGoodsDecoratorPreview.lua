local UICommonResItemGoodsBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemGoodsBase")
local UICommonResItemGoodsDecoratorPreview = BaseClass("UICommonResItemGoodsDecoratorPreview", UICommonResItemGoodsBase)
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
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
    local para5Num = tonumber(goods.para5) or 0
    if 0 < para5Num then
      UIUtil.OpenDecorationPrevieView(goods.para1, goods.id)
    else
      local param = {}
      param.itemId = self.param.itemId
      param.alignObject = self.item_icon
      param.hideHaveCountShow = self.param.hideHaveCountShow
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  end
end

UICommonResItemGoodsDecoratorPreview.OnCreate = OnCreate
UICommonResItemGoodsDecoratorPreview.OnDestroy = OnDestroy
UICommonResItemGoodsDecoratorPreview.ComponentDefine = ComponentDefine
UICommonResItemGoodsDecoratorPreview.ComponentDestroy = ComponentDestroy
UICommonResItemGoodsDecoratorPreview.DataDefine = DataDefine
UICommonResItemGoodsDecoratorPreview.DataDestroy = DataDestroy
UICommonResItemGoodsDecoratorPreview.OnClick = OnClick
return UICommonResItemGoodsDecoratorPreview
