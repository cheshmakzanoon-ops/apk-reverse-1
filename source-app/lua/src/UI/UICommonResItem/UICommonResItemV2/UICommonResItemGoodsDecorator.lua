local UICommonResItemGoodsBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemGoodsBase")
local UICommonResItemGoodsDecorator = BaseClass("UICommonResItemGoodsDecorator", UICommonResItemGoodsBase)
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
    local buildingId = tonumber(goods.para2)
    local baseBuildingId = CommonUtil.GetBuildBaseType(buildingId)
    local param = {}
    param.baseBuildingId = baseBuildingId
    param.alignObject = self.item_icon
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBookProperty, {anim = true}, param)
  end
end

UICommonResItemGoodsDecorator.OnCreate = OnCreate
UICommonResItemGoodsDecorator.OnDestroy = OnDestroy
UICommonResItemGoodsDecorator.ComponentDefine = ComponentDefine
UICommonResItemGoodsDecorator.ComponentDestroy = ComponentDestroy
UICommonResItemGoodsDecorator.DataDefine = DataDefine
UICommonResItemGoodsDecorator.DataDestroy = DataDestroy
UICommonResItemGoodsDecorator.OnClick = OnClick
return UICommonResItemGoodsDecorator
