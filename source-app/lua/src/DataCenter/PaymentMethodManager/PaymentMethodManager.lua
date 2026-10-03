local PaymentMethodManager = BaseClass("PaymentMethodManager")
local SDKManager = CS.SDKManager
PaymentMethodManager.MethodType = {External = 0, Native = 1}
PaymentMethodManager.PreferenceType = {
  External = PaymentMethodManager.MethodType.External,
  Native = PaymentMethodManager.MethodType.Native,
  AskEveryTime = 2
}
PaymentMethodManager.PlatformType = {IOS = 0, Android = 1}
PaymentMethodManager.PayType = {
  External = PaymentMethodManager.PreferenceType.External,
  Native = PaymentMethodManager.PreferenceType.Native,
  AskEveryTime = PaymentMethodManager.PreferenceType.AskEveryTime
}
PaymentMethodManager.MinUsExternalCheckoutVersion = "1.0.341"
PaymentMethodManager.RuntimeAvailability = {
  Unknown = 0,
  Available = 1,
  Unavailable = 2
}
local PayTypeToPreference = {
  [PaymentMethodManager.PayType.External] = PaymentMethodManager.PreferenceType.External,
  [PaymentMethodManager.PayType.Native] = PaymentMethodManager.PreferenceType.Native,
  [PaymentMethodManager.PayType.AskEveryTime] = PaymentMethodManager.PreferenceType.AskEveryTime
}
local PreferenceToPayType = {
  [PaymentMethodManager.PreferenceType.External] = PaymentMethodManager.PayType.External,
  [PaymentMethodManager.PreferenceType.Native] = PaymentMethodManager.PayType.Native,
  [PaymentMethodManager.PreferenceType.AskEveryTime] = PaymentMethodManager.PayType.AskEveryTime
}

local function GetCurrentPlatform()
  if SDKManager.IS_UNITY_IPHONE() then
    return PaymentMethodManager.PlatformType.IOS
  end
  if SDKManager.IS_UNITY_ANDROID() then
    return PaymentMethodManager.PlatformType.Android
  end
end

local function NormalizePreference(option)
  return PayTypeToPreference[PreferenceToPayType[option]] or PaymentMethodManager.PreferenceType.AskEveryTime
end

local function NormalizeMethod(method)
  if method == PaymentMethodManager.MethodType.External or method == PaymentMethodManager.MethodType.Native then
    return method
  end
end

local function ParseServerSwitchValue(value)
  if value == nil then
    return false
  end
  local numberValue = tonumber(value)
  if numberValue ~= nil then
    return numberValue == 1
  end
  return false
end

local function TryGetServerSwitchValue(message, key)
  if message == nil or string.IsNullOrEmpty(key) then
    return nil
  end
  local value = message[key]
  if value ~= nil then
    return value
  end
  local userData = message.user
  if type(userData) == "table" then
    return userData[key]
  end
  return nil
end

local function ParsePayModel(payModel)
  local preferences = {}
  if string.IsNullOrEmpty(payModel) then
    return preferences
  end
  for entry in string.gmatch(payModel, "[^|]+") do
    local platformText, payTypeText = string.match(entry, "^([^;]+);([^;]+)$")
    local platform = tonumber(platformText)
    local payType = tonumber(payTypeText)
    if platform ~= nil and payType ~= nil then
      preferences[platform] = PayTypeToPreference[payType] or PaymentMethodManager.PreferenceType.AskEveryTime
    end
  end
  return preferences
end

local function ClonePreferences(preferences)
  local result = {}
  for platform, option in pairs(preferences or {}) do
    result[platform] = option
  end
  return result
end

local function GetCurrentSdkVersion()
  local sdk = CS.GameEntry and CS.GameEntry.Sdk or nil
  if sdk == nil then
    return nil
  end
  return sdk.Version
end

local function GetPayOrderData()
  return CS.GameEntry and CS.GameEntry.PayOrderData or nil
end

local function NormalizeRuntimeAvailabilityValue(value)
  if value == nil then
    return PaymentMethodManager.RuntimeAvailability.Unknown
  end
  if type(value) == "number" then
    if value == PaymentMethodManager.RuntimeAvailability.Available or value == PaymentMethodManager.RuntimeAvailability.Unavailable then
      return value
    end
    return PaymentMethodManager.RuntimeAvailability.Unknown
  end
  if type(value) == "boolean" then
    if value then
      return PaymentMethodManager.RuntimeAvailability.Available
    end
    return PaymentMethodManager.RuntimeAvailability.Unavailable
  end
  local normalized = tostring(value):upper()
  if string.IsNullOrEmpty(normalized) then
    return PaymentMethodManager.RuntimeAvailability.Unknown
  end
  if normalized == "OK" or normalized == "AVAILABLE" or normalized == "TRUE" or normalized == "1" then
    return PaymentMethodManager.RuntimeAvailability.Available
  end
  return PaymentMethodManager.RuntimeAvailability.Unavailable
end

function PaymentMethodManager:__init()
  self.controlEnabled = false
  self.platformPreferences = {}
  self.serverPlatformPreferences = {}
  self.pendingPreferenceSync = false
  self.applePaymentFreeSwitch = false
  self.googlePaymentExternalContentlinksSwitch = false
  self.runtimeExternalCheckoutAvailability = PaymentMethodManager.RuntimeAvailability.Unknown
  self.pendingUiAvailabilityRefresh = false
end

function PaymentMethodManager:__delete()
  self.controlEnabled = nil
  self.platformPreferences = nil
  self.serverPlatformPreferences = nil
  self.pendingPreferenceSync = nil
  self.applePaymentFreeSwitch = nil
  self.googlePaymentExternalContentlinksSwitch = nil
  self.runtimeExternalCheckoutAvailability = nil
  self.pendingUiAvailabilityRefresh = nil
end

function PaymentMethodManager:RefreshState()
  self.controlEnabled = self:IsUsExternalCheckoutGreyEnabled() and self:CanUseUsExternalCheckoutForPaymentFlow() or false
  return self.controlEnabled
end

function PaymentMethodManager:IsControlEnabled()
  return self.controlEnabled
end

function PaymentMethodManager:CanShowPreferenceSettingForUI()
  return self:IsDefaultMethodSupported() and self:IsRuntimeExternalCheckoutAvailable()
end

function PaymentMethodManager:ShouldShowChooser()
  return self:IsControlEnabled() and self:ShouldShowUsPaymentMethodChooser()
end

function PaymentMethodManager:ShouldShowSaveDefaultToggle()
  return self:IsDefaultMethodSupported()
end

function PaymentMethodManager:IsDefaultMethodSupported()
  return self:IsControlEnabled() and self:ShouldShowUsPaymentMethodChooser() and self:IsDefaultPaymentSettingEnabled()
end

function PaymentMethodManager:InitData(message)
  self:ApplyExternalCheckoutConfig(message)
  self:ApplyServerPayModel(message and message.pay_model)
  self.runtimeExternalCheckoutAvailability = PaymentMethodManager.RuntimeAvailability.Unknown
  self:RefreshState()
end

function PaymentMethodManager:ApplyExternalCheckoutConfigUpdate(message)
  self:ApplyExternalCheckoutConfig(message)
  self:RefreshState()
end

function PaymentMethodManager:ApplyPayModelUpdate(message)
  self:ApplyServerPayModel(message and message.pay_model)
  self:RefreshState()
end

function PaymentMethodManager:ApplyExternalCheckoutConfig(message)
  self.applePaymentFreeSwitch = ParseServerSwitchValue(TryGetServerSwitchValue(message, "applePaymentFree"))
  self.googlePaymentExternalContentlinksSwitch = ParseServerSwitchValue(TryGetServerSwitchValue(message, "googlePaymentExternalContentlinks"))
end

function PaymentMethodManager:SetRuntimeExternalCheckoutAvailability(value)
  local normalized = NormalizeRuntimeAvailabilityValue(value)
  self.runtimeExternalCheckoutAvailability = normalized
  local payOrderData = GetPayOrderData()
  if payOrderData ~= nil and payOrderData.SaveExternalCheckoutAvailability ~= nil then
    payOrderData:SaveExternalCheckoutAvailability(normalized)
  end
end

function PaymentMethodManager:GetRuntimeExternalCheckoutAvailability()
  if self.runtimeExternalCheckoutAvailability ~= nil and self.runtimeExternalCheckoutAvailability ~= PaymentMethodManager.RuntimeAvailability.Unknown then
    return NormalizeRuntimeAvailabilityValue(self.runtimeExternalCheckoutAvailability)
  end
  return PaymentMethodManager.RuntimeAvailability.Unknown
end

function PaymentMethodManager:IsRuntimeExternalCheckoutAvailable()
  local availability = self:GetRuntimeExternalCheckoutAvailability()
  if availability == PaymentMethodManager.RuntimeAvailability.Unknown then
    return false
  end
  return availability == PaymentMethodManager.RuntimeAvailability.Available
end

function PaymentMethodManager:ApplyExternalCheckoutAvailabilityUpdate(result)
  self.pendingUiAvailabilityRefresh = false
  self:SetRuntimeExternalCheckoutAvailability(result)
  self:RefreshState()
  EventManager:GetInstance():Broadcast(EventId.ExternalCheckoutAvailabilityChanged)
end

function PaymentMethodManager:HasPendingUiAvailabilityRefresh()
  return self.pendingUiAvailabilityRefresh == true
end

function PaymentMethodManager:TryRefreshRuntimeExternalCheckoutAvailabilityForUI()
  if not self:IsDefaultMethodSupported() then
    self.pendingUiAvailabilityRefresh = false
    return false
  end
  if self:GetRuntimeExternalCheckoutAvailability() ~= PaymentMethodManager.RuntimeAvailability.Unknown then
    return true
  end
  if self.pendingUiAvailabilityRefresh == true then
    return true
  end
  local sdk = CS.GameEntry and CS.GameEntry.Sdk or nil
  local externalCheckout = sdk and sdk.ExternalCheckout or nil
  local checkAvailability = externalCheckout and externalCheckout.CheckUsExternalCheckoutAvailability or nil
  if checkAvailability == nil then
    self:ApplyExternalCheckoutAvailabilityUpdate(PaymentMethodManager.RuntimeAvailability.Unavailable)
    return false
  end
  self.pendingUiAvailabilityRefresh = true
  if checkAvailability(externalCheckout) then
    return true
  end
  self.pendingUiAvailabilityRefresh = false
  self:ApplyExternalCheckoutAvailabilityUpdate(PaymentMethodManager.RuntimeAvailability.Unavailable)
  return false
end

function PaymentMethodManager:IsUsExternalCheckoutServerSwitchOn()
  if SDKManager.IS_UNITY_IPHONE() then
    return self.applePaymentFreeSwitch == true
  end
  if SDKManager.IS_UNITY_ANDROID() then
    return self.googlePaymentExternalContentlinksSwitch == true
  end
  return false
end

function PaymentMethodManager:IsUsExternalCheckoutGreyEnabled()
  return LuaEntry.DataConfig:CheckSwitch("goldbrick_ingame")
end

function PaymentMethodManager:IsVNPackage()
  local sdk = CS.GameEntry and CS.GameEntry.Sdk or nil
  if sdk ~= nil and sdk.IsVNPlatform ~= nil then
    return sdk:IsVNPlatform() == true
  end
  return false
end

function PaymentMethodManager:IsReviewPackage()
  return CS.GameEntry.Setting.IsReview == true
end

function PaymentMethodManager:IsPCPlatform()
  return Config.IsPC()
end

function PaymentMethodManager:GetUsExternalCheckoutConfigId()
  if SDKManager.IS_UNITY_IPHONE() then
    return "apple_payment_free"
  end
  if SDKManager.IS_UNITY_ANDROID() then
    return "google_payment_external_contentlinks"
  end
  return nil
end

function PaymentMethodManager:IsDefaultPaymentSettingEnabled()
  local configId = self:GetUsExternalCheckoutConfigId()
  if string.IsNullOrEmpty(configId) then
    return false
  end
  return LuaEntry.DataConfig:TryGetNum(configId, "k5", 0) == 1
end

function PaymentMethodManager:GetUsPaymentMethodChooserMode()
  local configId = self:GetUsExternalCheckoutConfigId()
  if string.IsNullOrEmpty(configId) then
    return 0
  end
  return LuaEntry.DataConfig:TryGetNum(configId, "k4", 0)
end

function PaymentMethodManager:ShouldForceUsExternalCheckout()
  return self:GetUsPaymentMethodChooserMode() == 2
end

function PaymentMethodManager:ShouldShowUsPaymentMethodChooser()
  return self:GetUsPaymentMethodChooserMode() == 1
end

function PaymentMethodManager:IsUsExternalCheckoutVersionSupported()
  local currentVersion = GetCurrentSdkVersion()
  if string.IsNullOrEmpty(currentVersion) then
    return false
  end
  if SDKManager.IS_UNITY_IPHONE() then
    return true
  end
  return CS.StringUtils.VersionCompare(currentVersion, PaymentMethodManager.MinUsExternalCheckoutVersion) >= 0
end

function PaymentMethodManager:CanUseUsExternalCheckoutForPaymentFlow()
  if not self:IsUsExternalCheckoutServerSwitchOn() then
    return false
  end
  if self:IsReviewPackage() then
    return false
  end
  if not SDKManager.IS_UNITY_IPHONE() and not SDKManager.IS_UNITY_ANDROID() then
    return false
  end
  if self:IsVNPackage() or self:IsPCPlatform() then
    return false
  end
  if not self:IsUsExternalCheckoutVersionSupported() then
    return false
  end
  local sdk = CS.GameEntry and CS.GameEntry.Sdk or nil
  local externalCheckout = sdk and sdk.ExternalCheckout or nil
  local prepareExternalCheckout = externalCheckout and (externalCheckout.PrepareUsExternalCheckout or externalCheckout.LaunchConfiguredUsExternalCheckout) or nil
  if prepareExternalCheckout == nil then
    return false
  end
  return true
end

function PaymentMethodManager:CanUseUsExternalCheckout()
  return self:CanUseUsExternalCheckoutForPaymentFlow()
end

function PaymentMethodManager:ApplyServerPayModel(payModel)
  local preferences = ParsePayModel(payModel)
  self.serverPlatformPreferences = ClonePreferences(preferences)
  self.platformPreferences = ClonePreferences(preferences)
  self.pendingPreferenceSync = false
end

function PaymentMethodManager:RestoreServerPreferences()
  self.platformPreferences = ClonePreferences(self.serverPlatformPreferences)
  self.pendingPreferenceSync = false
end

function PaymentMethodManager:GetCurrentPlatformPreference()
  if not self:IsDefaultMethodSupported() then
    return PaymentMethodManager.PreferenceType.AskEveryTime
  end
  local platform = GetCurrentPlatform()
  if platform == nil then
    return PaymentMethodManager.PreferenceType.AskEveryTime
  end
  return NormalizePreference(self.platformPreferences[platform])
end

function PaymentMethodManager:SetCurrentPlatformPreference(option)
  if not self:IsDefaultMethodSupported() then
    return
  end
  local platform = GetCurrentPlatform()
  if platform == nil then
    return
  end
  self.platformPreferences[platform] = NormalizePreference(option)
end

function PaymentMethodManager:GetSavedDefaultMethod()
  local option = self:GetCurrentPlatformPreference()
  if option == PaymentMethodManager.PreferenceType.AskEveryTime then
    return nil
  end
  return option
end

function PaymentMethodManager:GetPreferenceOption()
  return self:GetCurrentPlatformPreference()
end

function PaymentMethodManager:GetDefaultMethod()
  if not self:IsControlEnabled() then
    return nil
  end
  return self:GetSavedDefaultMethod()
end

function PaymentMethodManager:SetDefaultMethod(method)
  local option = NormalizeMethod(method)
  if option == nil then
    return
  end
  self:SetCurrentPlatformPreference(option)
end

function PaymentMethodManager:ClearDefaultMethod()
  self:SetCurrentPlatformPreference(PaymentMethodManager.PreferenceType.AskEveryTime)
end

function PaymentMethodManager:ApplyPreferenceOption(option)
  self:SetCurrentPlatformPreference(option)
end

function PaymentMethodManager:SyncDefaultMethodToServer(method)
  return self:SyncPreferenceOptionToServer(NormalizeMethod(method))
end

function PaymentMethodManager:SyncPreferenceOptionToServer(option)
  if not self:IsDefaultMethodSupported() then
    return false
  end
  local platform = GetCurrentPlatform()
  if platform == nil then
    return false
  end
  self.pendingPreferenceSync = true
  SFSNetwork.SendMessage(MsgDefines.SavePayModel, platform, PreferenceToPayType[NormalizePreference(option)])
  return true
end

return PaymentMethodManager
