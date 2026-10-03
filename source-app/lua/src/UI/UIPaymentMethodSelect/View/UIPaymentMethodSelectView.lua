local UIPaymentMethodSelectView = BaseClass("UIPaymentMethodSelectView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SDKManager = CS.SDKManager
local MaxProductIconSize = 72
local DirectPayAppIconPath = "Assets/Main/Sprites/UI/UIDirectPay/app_icon.png"

local function TrackPayEvent(eventName)
  PostEventLog.Track(eventName, {})
end

local function GetNativeSaveEventName()
  if SDKManager.IS_UNITY_IPHONE() then
    return PostEventLog.Defines.save_pay_ios
  end
  return PostEventLog.Defines.save_pay_gp
end

local function ResolveProductName(packageInfo)
  if not packageInfo then
    return ""
  end
  return packageInfo:getNameText()
end

local function ResolveProductDesc(packageInfo)
  if not packageInfo then
    return ""
  end
  local descText = packageInfo:getDescText()
  if not string.IsNullOrEmpty(descText) then
    return descText
  end
  local priceText = packageInfo:getPriceText()
  if not string.IsNullOrEmpty(priceText) then
    return priceText
  end
  return ""
end

local function ResolveBonusText(packageInfo)
  if not packageInfo then
    return ""
  end
  local goldBrickId = packageInfo:getGoldBrickId()
  if not string.IsNullOrEmpty(goldBrickId) then
    local manager = DataCenter and DataCenter.GoldBrickTemplateManager or nil
    local value = manager and manager.GetFreeGoldBrick and manager:GetFreeGoldBrick(goldBrickId) or 0
    if value ~= nil and 0 < value then
      return "+" .. tostring(math.floor(value))
    end
  end
  return ""
end

local function RefreshProductIconSize(self)
  if self.imgProductIcon == nil or self.compProductIconMask == nil then
    return
  end
  local sprite = self.imgProductIcon:GetImage()
  if IsNull(sprite) then
    return
  end
  local width = sprite.rect.width
  local height = sprite.rect.height
  if width == nil or height == nil or width <= 0 or height <= 0 then
    self.compProductIconMask:SetSizeDeltaXY(MaxProductIconSize, MaxProductIconSize)
    self.imgProductIcon:SetSizeDeltaXY(MaxProductIconSize, MaxProductIconSize)
    return
  end
  local scale = math.min(MaxProductIconSize / width, MaxProductIconSize / height, 1)
  local iconWidth = math.floor(width * scale + 0.5)
  local iconHeight = math.floor(height * scale + 0.5)
  self.compProductIconMask:SetSizeDeltaXY(iconWidth, iconHeight)
  self.imgProductIcon:SetSizeDeltaXY(iconWidth, iconHeight)
end

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
  TrackPayEvent(PostEventLog.Defines.open_pay_select)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshSaveDefaultState(self)
  if self.btnSaveDefault == nil then
    return
  end
  if self.imgSaveDefaultCheckMark ~= nil then
    self.imgSaveDefaultCheckMark:SetEnable(self.saveDefaultSelected == true)
  end
end

local function RefreshSaveDefaultLayout(self)
  if self.compSaveDefaultOption ~= nil then
    self.compSaveDefaultOption:SetActive(self.showSaveDefaultToggle)
  end
end

local function ComponentDefine(self)
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.imgCloseBtn = self.viewSkin:AddComponent(self, UIImage, 2)
  self.btnOverlay = self.viewSkin:AddComponent(self, UIButton, 3)
  self.imgOverlay = self.viewSkin:AddComponent(self, UIImage, 4)
  self.compPopup = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.imgPopupBg = self.viewSkin:AddComponent(self, UIImage, 6)
  self.txtTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 8)
  self.imgClose = self.viewSkin:AddComponent(self, UIImage, 9)
  self.compProductCard = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.compProductIconMask = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.compSaveDefaultOption = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.imgProductIcon = self.viewSkin:AddComponent(self, UIImage, 13)
  self.txtProductName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.txtProductDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.btnCheckout = self.viewSkin:AddComponent(self, UIButton, 16)
  self.txtCheckout = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.imgBonusIcon = self.viewSkin:AddComponent(self, UIImage, 18)
  self.txtBonus = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.txtSecureHint = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.compIapBorder = self.viewSkin:AddComponent(self, UIBaseContainer, 21)
  self.btnIap = self.viewSkin:AddComponent(self, UIButton, 22)
  self.txtIap = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 23)
  self.btnSaveDefault = self.viewSkin:AddComponent(self, UIButton, 24)
  self.imgSaveDefaultCheckMark = self.viewSkin:AddComponent(self, UIImage, 25)
  self.txtSaveDefault = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 26)
  self.btnOverlay:SetOnClick(function()
    self:OnCloseClick()
  end)
  self.btnClose:SetOnClick(function()
    self:OnCloseClick()
  end)
  self.btnCheckout:SetOnClick(function()
    self:OnCheckoutClick()
  end)
  self.btnIap:SetOnClick(function()
    self:OnIapClick()
  end)
  if self.btnSaveDefault ~= nil then
    self.btnSaveDefault:SetOnClick(function()
      self:OnSaveDefaultClick()
    end)
  end
end

local function ComponentDestroy(self)
  self.viewSkin = nil
  self.compRoot = nil
  self.imgCloseBtn = nil
  self.btnOverlay = nil
  self.imgOverlay = nil
  self.compPopup = nil
  self.imgPopupBg = nil
  self.btnClose = nil
  self.txtTitle = nil
  self.imgClose = nil
  self.compProductCard = nil
  self.compProductIconMask = nil
  self.txtProductName = nil
  self.txtProductDesc = nil
  self.imgProductIcon = nil
  self.btnCheckout = nil
  self.txtCheckout = nil
  self.imgBonusIcon = nil
  self.txtBonus = nil
  self.txtSecureHint = nil
  self.compIapBorder = nil
  self.btnIap = nil
  self.txtIap = nil
  self.compSaveDefaultOption = nil
  self.btnSaveDefault = nil
  self.imgSaveDefaultCheckMark = nil
  self.txtSaveDefault = nil
end

local function DataDefine(self)
  local param = self:GetUserData() or {}
  self.packageInfo = param.packageInfo
  self.showSaveDefaultToggle = param.showSaveDefaultToggle == true
  self.saveDefaultSelected = param.defaultSaveDefault == true
  self.onSaveDefaultChanged = param.onSaveDefaultChanged
  self.onExternalSelect = param.onExternalSelect
  self.onNativeSelect = param.onNativeSelect
  self.onClose = param.onClose
  self.txtProductName:SetText(param.productName or ResolveProductName(self.packageInfo))
  self.txtProductDesc:SetText(param.productDesc or ResolveProductDesc(self.packageInfo))
  local bonusText = param.bonusText
  if string.IsNullOrEmpty(bonusText) then
    bonusText = ResolveBonusText(self.packageInfo)
  end
  local showBonus = not string.IsNullOrEmpty(bonusText)
  self.imgBonusIcon:SetActive(showBonus)
  self.txtBonus:SetActive(showBonus)
  if showBonus then
    self.txtBonus:SetText(bonusText)
  end
  local iconPath = DirectPayAppIconPath
  self.imgProductIcon:LoadSpriteAsyncWithCallback(iconPath, function()
    if self.imgProductIcon == nil then
      return
    end
    RefreshProductIconSize(self)
  end)
  RefreshSaveDefaultLayout(self)
  RefreshSaveDefaultState(self)
end

local function DataDestroy(self)
  self.packageInfo = nil
  self.showSaveDefaultToggle = nil
  self.saveDefaultSelected = nil
  self.onSaveDefaultChanged = nil
  self.onExternalSelect = nil
  self.onNativeSelect = nil
  self.onClose = nil
end

local function OnSaveDefaultClick(self)
  local lastSelected = self.saveDefaultSelected == true
  self.saveDefaultSelected = self.saveDefaultSelected ~= true
  RefreshSaveDefaultState(self)
  if self.onSaveDefaultChanged ~= nil then
    self.onSaveDefaultChanged(self.saveDefaultSelected)
  end
end

local function OnCloseClick(self)
  if self.onClose ~= nil then
    self.onClose()
  end
  self.ctrl:CloseSelf()
end

local function OnCheckoutClick(self)
  TrackPayEvent(PostEventLog.Defines.pay_redirect)
  if self.saveDefaultSelected == true then
    TrackPayEvent(PostEventLog.Defines.save_pay_redirect)
  end
  if self.onExternalSelect ~= nil then
    self.onExternalSelect()
  end
  self.ctrl:CloseSelf()
end

local function OnIapClick(self)
  if self.saveDefaultSelected == true then
    TrackPayEvent(GetNativeSaveEventName())
  end
  if self.onNativeSelect ~= nil then
    self.onNativeSelect()
  end
  self.ctrl:CloseSelf()
end

UIPaymentMethodSelectView.OnCreate = OnCreate
UIPaymentMethodSelectView.OnDestroy = OnDestroy
UIPaymentMethodSelectView.OnEnable = OnEnable
UIPaymentMethodSelectView.OnDisable = OnDisable
UIPaymentMethodSelectView.ComponentDefine = ComponentDefine
UIPaymentMethodSelectView.ComponentDestroy = ComponentDestroy
UIPaymentMethodSelectView.DataDefine = DataDefine
UIPaymentMethodSelectView.DataDestroy = DataDestroy
UIPaymentMethodSelectView.OnSaveDefaultClick = OnSaveDefaultClick
UIPaymentMethodSelectView.OnCloseClick = OnCloseClick
UIPaymentMethodSelectView.OnCheckoutClick = OnCheckoutClick
UIPaymentMethodSelectView.OnIapClick = OnIapClick
return UIPaymentMethodSelectView
