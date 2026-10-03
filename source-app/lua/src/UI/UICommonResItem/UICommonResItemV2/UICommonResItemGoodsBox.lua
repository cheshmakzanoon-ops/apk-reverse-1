local UICommonResItemGoodsBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemGoodsBase")
local UICommonResItemGoodsBox = BaseClass("UICommonResItemGoodsBox", UICommonResItemGoodsBase)
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
    local param = {}
    param.itemId = self.param.itemId
    param.alignObject = self.item_icon
    param.showArrow = true
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
    if itemTemplate and itemTemplate.tipsType == GOODS_TIPS_TYPE.BoxTacticalCard then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardChoiceBoxTips, {anim = true}, param)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBoxItemTips, {anim = true}, param)
    end
  end
end

UICommonResItemGoodsBox.OnCreate = OnCreate
UICommonResItemGoodsBox.OnDestroy = OnDestroy
UICommonResItemGoodsBox.ComponentDefine = ComponentDefine
UICommonResItemGoodsBox.ComponentDestroy = ComponentDestroy
UICommonResItemGoodsBox.DataDefine = DataDefine
UICommonResItemGoodsBox.DataDestroy = DataDestroy
UICommonResItemGoodsBox.OnClick = OnClick
return UICommonResItemGoodsBox
