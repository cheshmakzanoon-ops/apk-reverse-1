local CommonDecorationRowShopItem = BaseClass("CommonDecorationRowShopItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local CommonDecorationShopItem = require("UI.UICommonShop.Component.CommonShopDecoration.CommonDecorationShopItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.compCommonDecorationShopItem1 = self:AddComponent(CommonDecorationShopItem, "CommonDecorationShopItem1")
  self.compCommonDecorationShopItem2 = self:AddComponent(CommonDecorationShopItem, "CommonDecorationShopItem2")
  self.compCommonDecorationShopItem3 = self:AddComponent(CommonDecorationShopItem, "CommonDecorationShopItem3")
end

local function ComponentDestroy(self)
  self.compCommonDecorationShopItem1 = nil
  self.compCommonDecorationShopItem2 = nil
  self.compCommonDecorationShopItem3 = nil
end

local function DataDefine(self)
  self.curShopType = nil
  self.shopItemList = {
    self.compCommonDecorationShopItem1,
    self.compCommonDecorationShopItem2,
    self.compCommonDecorationShopItem3
  }
end

local function DataDestroy(self)
  self.curShopType = nil
  self.shopItemList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, goodsInfo, shopType)
  self.curShopType = shopType
  for i = 1, 3 do
    if goodsInfo[i] then
      self.shopItemList[i]:SetActive(true)
      self.shopItemList[i]:SetItem(goodsInfo[i], self.curShopType)
    else
      self.shopItemList[i]:SetActive(false)
    end
  end
end

CommonDecorationRowShopItem.OnCreate = OnCreate
CommonDecorationRowShopItem.OnDestroy = OnDestroy
CommonDecorationRowShopItem.OnEnable = OnEnable
CommonDecorationRowShopItem.OnDisable = OnDisable
CommonDecorationRowShopItem.ComponentDefine = ComponentDefine
CommonDecorationRowShopItem.ComponentDestroy = ComponentDestroy
CommonDecorationRowShopItem.DataDefine = DataDefine
CommonDecorationRowShopItem.DataDestroy = DataDestroy
CommonDecorationRowShopItem.OnAddListener = OnAddListener
CommonDecorationRowShopItem.OnRemoveListener = OnRemoveListener
CommonDecorationRowShopItem.SetData = SetData
return CommonDecorationRowShopItem
