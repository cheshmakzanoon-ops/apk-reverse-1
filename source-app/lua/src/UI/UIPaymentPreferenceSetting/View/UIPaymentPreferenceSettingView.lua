local UIPaymentPreferenceSettingView = BaseClass("UIPaymentPreferenceSettingView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SDKManager = CS.SDKManager
local PaymentMethodManager = DataCenter.PaymentMethodManager
local DefaultPreferenceOption = PaymentMethodManager.PreferenceType.AskEveryTime
local OptionIconMaxSize = 60
local RootPath = "PaymentMethodSelectPop/UICommonPopUpPanel_NoToggle/Content"
local OptionConfig = {
  {
    key = PaymentMethodManager.PreferenceType.External,
    iconPath = "Assets/Main/Sprites/UI/UIDirectPay/wxy_wangye_logo_guanwang.png",
    iconScale = 1,
    showBonus = true
  },
  {
    key = PaymentMethodManager.PreferenceType.Native,
    iconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_zhbd_google_icon.png",
    iconScale = 1,
    showBonus = false
  },
  {
    key = PaymentMethodManager.PreferenceType.AskEveryTime,
    iconPath = "Assets/Main/Sprites/UI/UIDirectPay/zxl_s1_tianqi_wenhao.png",
    iconScale = 1,
    showBonus = false
  }
}

local function TrackPreferenceSaveEvent(option)
  if option == PaymentMethodManager.PreferenceType.External then
    PostEventLog.Track(PostEventLog.Defines.save_pay_redirect, {})
    return
  end
  if option == PaymentMethodManager.PreferenceType.Native then
    if SDKManager.IS_UNITY_IPHONE() then
      PostEventLog.Track(PostEventLog.Defines.save_pay_ios, {})
    else
      PostEventLog.Track(PostEventLog.Defines.save_pay_gp, {})
    end
    return
  end
  PostEventLog.Track(PostEventLog.Defines.save_pay_inquiry, {})
end

local function ResolveOptionName(optionKey, manager)
  if optionKey == PaymentMethodManager.PreferenceType.External then
    local localized = Localization:GetString("goldbrick_limit_desc3")
    return localized or ""
  end
  if optionKey == PaymentMethodManager.PreferenceType.Native then
    local localized = Localization:GetString("goldbrick_limit_desc2")
    return localized or ""
  end
  local localized = Localization:GetString("goldbrick_limit_desc4")
  if not string.IsNullOrEmpty(localized) then
    return localized
  end
  return ""
end

local function RefreshOptionState(self)
  if self.optionItems == nil then
    return
  end
  for _, config in ipairs(OptionConfig) do
    local optionItem = self.optionItems[config.key]
    if optionItem ~= nil and optionItem.checkMark ~= nil then
      optionItem.checkMark:SetEnable(self.selectedOption == config.key)
    end
  end
end

local function ClearOptionItems(self)
  if self.optionTemplate ~= nil and self.optionTemplate.gameObject ~= nil then
    self.optionTemplate.gameObject:GameObjectRecycleAll()
  end
  self.optionItems = {}
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
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function CreateOptionItem(self, config, index)
  local optionGo = self.optionTemplate.gameObject:GameObjectSpawn(self.typesContainer.transform)
  optionGo.name = "Option_" .. config.key
  optionGo.transform:SetSiblingIndex(index - 1)
  optionGo:SetActive(true)
  local optionRoot = self.typesContainer:AddComponent(UIBaseContainer, optionGo.name)
  local optionButton = optionRoot:AddComponent(UIButton, "checkBox/Image/raycast")
  optionButton:SetOnClick(function()
    self:OnSelectOption(config.key)
  end)
  local optionCheckMark = optionRoot:AddComponent(UIImage, "checkBox/Image")
  local optionName = optionRoot:AddComponent(UITextMeshProUGUIEx, "tip/typeName_txt")
  local optionBonus = optionRoot:AddComponent(UIBaseContainer, "tip/bonus")
  local optionIcon = optionRoot:AddComponent(UIImage, "tip/icon")
  optionName:SetText(ResolveOptionName(config.key, self.paymentMethodManager))
  optionBonus:SetActive(config.showBonus)
  optionCheckMark:SetEnable(false)
  optionIcon:SetAspectSize(OptionIconMaxSize)
  optionIcon:SetLocalScaleXYZ(config.iconScale, config.iconScale, 1)
  if not string.IsNullOrEmpty(config.iconPath) then
    optionIcon:LoadSpriteAuto(config.iconPath)
  end
  self.optionItems[config.key] = {
    root = optionRoot,
    button = optionButton,
    checkMark = optionCheckMark,
    name = optionName,
    bonus = optionBonus,
    icon = optionIcon
  }
end

local function ComponentDefine(self)
  self.paymentMethodManager = PaymentMethodManager
  if SDKManager.IS_UNITY_IPHONE() then
    OptionConfig[2].iconPath = "Assets/Main/Sprites/UI/UIDirectPay/lyt_yunying_qingchushebei_ios.png"
    OptionConfig[2].iconScale = 1
  else
    OptionConfig[2].iconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_zhbd_google_icon.png"
    OptionConfig[2].iconScale = 0.8
  end
  self.tipText = self:AddComponent(UITextMeshProUGUIEx, RootPath .. "/MainRoot/tip_txt")
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, RootPath .. "/UICommonPopUpTop/TitleText")
  self.btnMask = self:AddComponent(UIButton, "PaymentMethodSelectPop/UICommonPopUpPanel_NoToggle/Mask")
  self.btnClose = self:AddComponent(UIButton, RootPath .. "/UICommonPopUpTop/CloseBtn")
  self.btnMask:SetOnClick(function()
    self:OnCancelClick()
  end)
  self.btnClose:SetOnClick(function()
    self:OnCancelClick()
  end)
  self.btnCancel = self:AddComponent(UIButton, RootPath .. "/BottomGroup/ButtonScaleNode/CommonButton (1)")
  self.btnCancelText = self.btnCancel:AddComponent(UITextMeshProUGUIEx, "Content/ButtonText")
  self.btnCancel:SetOnClick(function()
    self:OnCancelClick()
  end)
  self.btnConfirm = self:AddComponent(UIButton, RootPath .. "/BottomGroup/ButtonScaleNode/CommonButton")
  self.btnConfirmText = self.btnConfirm:AddComponent(UITextMeshProUGUIEx, "Content/ButtonText")
  self.btnConfirm:SetOnClick(function()
    self:OnConfirmClick()
  end)
  self.typesContainer = self:AddComponent(UIBaseContainer, RootPath .. "/MainRoot/types")
  self.optionTemplate = self:AddComponent(UIBaseContainer, RootPath .. "/MainRoot/types/typeItem")
  ClearOptionItems(self)
  self.optionItems = {}
  if self.optionTemplate ~= nil then
    self.optionTemplate.gameObject:SetActive(false)
    self.optionTemplate.gameObject:GameObjectCreatePool()
    for index, config in ipairs(OptionConfig) do
      CreateOptionItem(self, config, index)
    end
  end
end

local function ComponentDestroy(self)
  ClearOptionItems(self)
  self.tipText = nil
  self.titleText = nil
  self.btnMask = nil
  self.btnClose = nil
  self.btnCancel = nil
  self.btnCancelText = nil
  self.btnConfirm = nil
  self.btnConfirmText = nil
  self.typesContainer = nil
  self.optionItems = nil
  self.optionTemplate = nil
end

local function DataDefine(self)
  self.selectedOption = self.paymentMethodManager:GetPreferenceOption() or DefaultPreferenceOption
  RefreshOptionState(self)
end

local function DataDestroy(self)
  self.paymentMethodManager = nil
  self.selectedOption = nil
end

local function OnCancelClick(self)
  self.ctrl:CloseSelf()
end

local function OnSelectOption(self, option)
  self.selectedOption = option
  RefreshOptionState(self)
end

local function OnConfirmClick(self)
  TrackPreferenceSaveEvent(self.selectedOption)
  self.paymentMethodManager:ApplyPreferenceOption(self.selectedOption)
  if not self.paymentMethodManager:SyncPreferenceOptionToServer(self.selectedOption) and self.paymentMethodManager.RestoreServerPreferences ~= nil then
    self.paymentMethodManager:RestoreServerPreferences()
  end
  self.ctrl:CloseSelf()
end

UIPaymentPreferenceSettingView.OnCreate = OnCreate
UIPaymentPreferenceSettingView.OnDestroy = OnDestroy
UIPaymentPreferenceSettingView.OnEnable = OnEnable
UIPaymentPreferenceSettingView.OnDisable = OnDisable
UIPaymentPreferenceSettingView.ComponentDefine = ComponentDefine
UIPaymentPreferenceSettingView.ComponentDestroy = ComponentDestroy
UIPaymentPreferenceSettingView.DataDefine = DataDefine
UIPaymentPreferenceSettingView.DataDestroy = DataDestroy
UIPaymentPreferenceSettingView.OnCancelClick = OnCancelClick
UIPaymentPreferenceSettingView.OnSelectOption = OnSelectOption
UIPaymentPreferenceSettingView.OnConfirmClick = OnConfirmClick
return UIPaymentPreferenceSettingView
