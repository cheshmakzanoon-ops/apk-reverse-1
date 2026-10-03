local UICommonResItemGoodsBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemGoodsBase")
local UICommonResItemGoodsGoldBrick = BaseClass("UICommonResItemGoodsGoldBrick", UICommonResItemGoodsBase)
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

local function OnReInit(self)
  base.OnReInit(self)
  if self.param.count and self.param.itemId then
    local countStr = string.GetFormattedStr2(self.param.count)
    self:SetItemCount(countStr)
  end
end

UICommonResItemGoodsGoldBrick.OnCreate = OnCreate
UICommonResItemGoodsGoldBrick.OnDestroy = OnDestroy
UICommonResItemGoodsGoldBrick.ComponentDefine = ComponentDefine
UICommonResItemGoodsGoldBrick.ComponentDestroy = ComponentDestroy
UICommonResItemGoodsGoldBrick.DataDefine = DataDefine
UICommonResItemGoodsGoldBrick.DataDestroy = DataDestroy
UICommonResItemGoodsGoldBrick.OnReInit = OnReInit
return UICommonResItemGoodsGoldBrick
