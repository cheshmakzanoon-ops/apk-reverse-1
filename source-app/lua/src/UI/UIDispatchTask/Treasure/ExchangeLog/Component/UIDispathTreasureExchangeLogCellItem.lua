local UIDispathTreasureExchangeLogCellItem = BaseClass("UIDispathTreasureExchangeLogCellItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")
local UISplinterExchangeItem = require("UI.UISplinterExchange.Component.UISplinterExchangeItem")

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
  self.playerHead = self:AddComponent(UICommonHead, "Head/PlayerHead")
  self.exchangeItem = self:AddComponent(UISplinterExchangeItem, "UISplinterExchangeItem")
  self.nameText = self:AddComponent(UIText, "Name")
  self.playerHead:SetEnableClickShowInfo(true, true)
end

local function ComponentDestroy(self)
  self.playerHead = nil
  self.exchangeItem = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, data, isLeft)
  local type
  if DataCenter.DigTreasureManager:IsActivityOpen() or DataCenter.DigTreasureManager:IsNewActivityOpen() then
    type = SplinterExchangeType.DigTreasure.Id
  else
    type = SplinterExchangeType.DispatchTreasure.Id
  end
  if isLeft then
    self.exchangeItem:SetData(data.getFragment, DispathTreasureExchangeItemType.Down, DataCenter.SplinterExchangeManager:GetIndexStrByGoodsId(type, data.getFragment))
    self.exchangeItem:HideOwnNumText()
    self.exchangeItem:SetNumText(1)
    self.exchangeItem:HideNoItemImg()
    self.playerHead:ParseHeadInfo(data.leftInfo)
    self.nameText:SetText(data.leftInfo.name)
    if data.leftInfo.uid == LuaEntry.Player:GetUid() then
      self.nameText:SetColorRGBA255(9, 155, 58, 255)
    else
      self.nameText:SetColorRGBA255(42, 40, 48, 255)
    end
  else
    self.exchangeItem:SetData(data.costFragment, DispathTreasureExchangeItemType.Down, DataCenter.SplinterExchangeManager:GetIndexStrByGoodsId(type, data.costFragment))
    self.exchangeItem:HideOwnNumText()
    self.exchangeItem:SetNumText(1)
    self.exchangeItem:HideNoItemImg()
    self.playerHead:ParseHeadInfo(data)
    self.nameText:SetText(data.name)
    if data.uid == LuaEntry.Player:GetUid() then
      self.nameText:SetColorRGBA255(9, 155, 58, 255)
    else
      self.nameText:SetColorRGBA255(42, 40, 48, 255)
    end
  end
end

UIDispathTreasureExchangeLogCellItem.OnCreate = OnCreate
UIDispathTreasureExchangeLogCellItem.OnDestroy = OnDestroy
UIDispathTreasureExchangeLogCellItem.OnEnable = OnEnable
UIDispathTreasureExchangeLogCellItem.OnDisable = OnDisable
UIDispathTreasureExchangeLogCellItem.ComponentDefine = ComponentDefine
UIDispathTreasureExchangeLogCellItem.ComponentDestroy = ComponentDestroy
UIDispathTreasureExchangeLogCellItem.DataDefine = DataDefine
UIDispathTreasureExchangeLogCellItem.DataDestroy = DataDestroy
UIDispathTreasureExchangeLogCellItem.OnAddListener = OnAddListener
UIDispathTreasureExchangeLogCellItem.OnRemoveListener = OnRemoveListener
UIDispathTreasureExchangeLogCellItem.SetData = SetData
return UIDispathTreasureExchangeLogCellItem
