local base = UIBaseView
local UISplinterExchangeConfirmView = BaseClass("UISplinterExchangeConfirmView", base)
local UISplinterExchangeItem = require("UI.UISplinterExchange.Component.UISplinterExchangeItem")
local TitleTxt_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local CloseBtn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local ReceiveItem_path = "Root/Content/ContentHolder/TopBgImg/ReceiveItem"
local LoseItem_path = "Root/Content/ContentHolder/TopBgImg/LoseItem"
local TipText_path = "Root/Content/ContentHolder/TipText"
local SureBtn_path = "Root/Content/ContentHolder/SureBtn"
local SureText_path = "Root/Content/ContentHolder/SureBtn/SureText"
local ReceiveItemNumText_path = "Root/Content/ContentHolder/TopBgImg/ReceiveItemNumText"
local LoseItemNumText_path = "Root/Content/ContentHolder/TopBgImg/LoseItemNumText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.data = self:GetUserData()
  self:Refresh()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.TitleTxt = self:AddComponent(UIText, TitleTxt_path)
  self.CloseBtn = self:AddComponent(UIButton, CloseBtn_path)
  self.ReceiveItem = self:AddComponent(UISplinterExchangeItem, ReceiveItem_path)
  self.LoseItem = self:AddComponent(UISplinterExchangeItem, LoseItem_path)
  self.TipText = self:AddComponent(UITextMeshProUGUIEx, TipText_path)
  self.SureBtn = self:AddComponent(UIButton, SureBtn_path)
  self.SureText = self:AddComponent(UITextMeshProUGUIEx, SureText_path)
  self.ReceiveItemNumText = self:AddComponent(UITextMeshProUGUIEx, ReceiveItemNumText_path)
  self.LoseItemNumText = self:AddComponent(UITextMeshProUGUIEx, LoseItemNumText_path)
  self.CloseBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.ClosePanel = self:AddComponent(UIButton, "Panel")
  self.ClosePanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.SureBtn:SetOnClick(function()
    self.data.callback()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.TitleTxt = nil
  self.CloseBtn = nil
  self.ReceiveItem = nil
  self.LoseItem = nil
  self.TipText = nil
  self.SureBtn = nil
  self.SureText = nil
  self.ReceiveItemNumText = nil
  self.LoseItemNumText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.data = nil
end

local function Refresh(self)
  self.ReceiveItem:SetData(self.data.receiveFragId, DispathTreasureExchangeItemType.None, DataCenter.SplinterExchangeManager:GetIndexStrByGoodsId(self.data.type, self.data.receiveFragId))
  self.ReceiveItem:SetTitleText("Treasure_map_09")
  self.ReceiveItem:ShowIdTextBg()
  self.LoseItem:SetData(self.data.loseFragId, DispathTreasureExchangeItemType.None, DataCenter.SplinterExchangeManager:GetIndexStrByGoodsId(self.data.type, self.data.loseFragId))
  self.LoseItem:SetTitleText("Treasure_map_08")
  self.LoseItem:ShowIdTextBg()
  local itemData = DataCenter.ItemData:GetItemByItemId(tonumber(self.data.receiveFragId))
  local fragNum = itemData and itemData.count or 0
  self.ReceiveItemNumText:SetLocalText("Treasure_map_33", fragNum)
  itemData = DataCenter.ItemData:GetItemByItemId(tonumber(self.data.loseFragId))
  fragNum = itemData and itemData.count or 0
  self.LoseItemNumText:SetLocalText("Treasure_map_33", fragNum)
  local name1 = DataCenter.ItemTemplateManager:GetName(self.data.loseFragId)
  local name2 = DataCenter.ItemTemplateManager:GetName(self.data.receiveFragId)
  self.TipText:SetLocalText("Treasure_map_12", name1, name2)
  self.SureText:SetLocalText("Treasure_map_16")
  self.TitleTxt:SetLocalText(self.data.titleDialogId)
  self:RefreshEx()
end

local function RefreshEx(self)
  if self.data.type == SplinterExchangeType.DispatchTreasure.Id or self.data.type == SplinterExchangeType.DigTreasure.Id then
    self.LoseItem:ShowIdTextBg()
    self.ReceiveItem:ShowIdTextBg()
  else
  end
end

UISplinterExchangeConfirmView.OnCreate = OnCreate
UISplinterExchangeConfirmView.OnDestroy = OnDestroy
UISplinterExchangeConfirmView.OnEnable = OnEnable
UISplinterExchangeConfirmView.OnDisable = OnDisable
UISplinterExchangeConfirmView.ComponentDefine = ComponentDefine
UISplinterExchangeConfirmView.ComponentDestroy = ComponentDestroy
UISplinterExchangeConfirmView.DataDefine = DataDefine
UISplinterExchangeConfirmView.DataDestroy = DataDestroy
UISplinterExchangeConfirmView.Refresh = Refresh
UISplinterExchangeConfirmView.RefreshEx = RefreshEx
return UISplinterExchangeConfirmView
