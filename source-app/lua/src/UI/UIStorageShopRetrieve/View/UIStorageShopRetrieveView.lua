local base = UIBaseView
local UIStorageShopRetrieveView = BaseClass("UIStorageShopRetrieveView", base)
local Localization = CS.GameEntry.Localization
local title_path = "UICommonMiniPopUpTitle/titleText"
local closeBtn_path = "UICommonMiniPopUpTitle/CloseBtn"
local goodsIcon_path = "Container/StorageShopSlotItem/goods/iconImage"
local goodsNum_path = "Container/StorageShopSlotItem/goods/NumText"
local price_path = "Container/StorageShopSlotItem/goods/priceBg/price"
local confirmBtn_path = "BtnGo/RightBtn"
local confirmBtnTxt_path = "BtnGo/RightBtn/RightBtnName"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshAll()
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(141049)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.goodsIconN = self:AddComponent(UIImage, goodsIcon_path)
  self.goodsNumN = self:AddComponent(UIText, goodsNum_path)
  self.priceN = self:AddComponent(UIText, price_path)
  self.confirmBtnN = self:AddComponent(UIButton, confirmBtn_path)
  self.confirmBtnN:SetOnClick(function()
    self:OnClickConfirmBtn()
  end)
  self.confirmBtnTxtN = self:AddComponent(UIText, confirmBtnTxt_path)
  self.confirmBtnTxtN:SetLocalText(141049)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.closeBtnN = nil
  self.goodsIconN = nil
  self.goodsNumN = nil
  self.priceN = nil
  self.confirmBtnN = nil
  self.confirmBtnTxtN = nil
end

local function DataDefine(self)
  self.curSlotInfo = nil
end

local function DataDestroy(self)
  self.curSlotInfo = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function RefreshAll(self)
  self.curSlotInfo = self:GetUserData()
  local itemTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.curSlotInfo.itemId)
  self.goodsIconN:LoadSprite(itemTemplate:GetIconPath())
  self.goodsNumN:SetText(self.curSlotInfo.num .. "x")
  self.priceN:SetText(self.curSlotInfo.price)
end

local function OnClickConfirmBtn(self)
  SFSNetwork.SendMessage(MsgDefines.StorageShopRemoveGoods, self.curSlotInfo.uuid)
  self.ctrl:CloseSelf()
end

UIStorageShopRetrieveView.OnCreate = OnCreate
UIStorageShopRetrieveView.OnDestroy = OnDestroy
UIStorageShopRetrieveView.OnAddListener = OnAddListener
UIStorageShopRetrieveView.OnRemoveListener = OnRemoveListener
UIStorageShopRetrieveView.ComponentDefine = ComponentDefine
UIStorageShopRetrieveView.ComponentDestroy = ComponentDestroy
UIStorageShopRetrieveView.DataDefine = DataDefine
UIStorageShopRetrieveView.DataDestroy = DataDestroy
UIStorageShopRetrieveView.RefreshAll = RefreshAll
UIStorageShopRetrieveView.OnClickConfirmBtn = OnClickConfirmBtn
return UIStorageShopRetrieveView
