local UIExternalCheckoutCtrl = BaseClass("UIExternalCheckoutCtrl", UIBaseCtrl)
local rapidjson = require("rapidjson")
local PaymentWebViewSource = "Payment"
local PaymentWebEventName = {
  CloseWebView = "CloseWebView",
  OpenExternalBrowser = "OpenExternalBrowser"
}

local function OnWebViewFireEvent(self, eventJson)
  if string.IsNullOrEmpty(eventJson) then
    return
  end
  local ok, eventData = pcall(rapidjson.decode, eventJson)
  if not ok or eventData == nil or type(eventData) ~= "table" then
    return
  end
  if eventData.source ~= PaymentWebViewSource or type(eventData.data) ~= "table" then
    return
  end
  local eventName = tostring(eventData.data.event_name or "")
  local info = eventData.data.info
  if eventName == PaymentWebEventName.CloseWebView then
    self:CloseSelf()
    return
  end
  if eventName == PaymentWebEventName.OpenExternalBrowser then
    local url = info ~= nil and info.url or nil
    if string.IsNullOrEmpty(url) then
      PayPrint("Skip external checkout web event OpenExternalBrowser, url empty")
      return
    end
    CS.SDKManager.OpenURL(url)
    return
  end
  PayPrint("Unknown external checkout web event, eventName=%s payload=%s", tostring(eventName), tostring(eventJson))
end

local function CloseSelf(self)
  if self._isClosing == true then
    return
  end
  self._isClosing = true
  local payManager = DataCenter and DataCenter.PayManager or nil
  if payManager ~= nil and payManager.OnExternalCheckoutWindowClosedByUser ~= nil then
    payManager:OnExternalCheckoutWindowClosedByUser()
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIExternalCheckout) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIExternalCheckout)
  end
end

local function CreateExternalCheckoutView(self, container, url)
  if IsNull(container) or string.IsNullOrEmpty(url) then
    return
  end
  CS.UnityEngine.Canvas.ForceUpdateCanvases()
  CS.YieldUtils.DoEndOfFrame(CS.ApplicationLaunch.Instance, function()
    if self._isClosing == true or container == nil or not ComponentIsValid(container) then
      return
    end
    local containerGameObject = container.gameObject
    if IsNull(containerGameObject) then
      return
    end
    CS.UnityEngine.Canvas.ForceUpdateCanvases()
    CS.ZendeskSupportView.Show(containerGameObject, url, function()
      self:CloseSelf()
    end)
  end)
end

local function CloseExternalCheckoutView(self)
  self._isClosing = true
  CS.ZendeskSupportView.Close()
end

local function OnCustomKeyCodeEscape(self)
  self:CloseSelf()
end

UIExternalCheckoutCtrl.CloseSelf = CloseSelf
UIExternalCheckoutCtrl.CreateExternalCheckoutView = CreateExternalCheckoutView
UIExternalCheckoutCtrl.CloseExternalCheckoutView = CloseExternalCheckoutView
UIExternalCheckoutCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
UIExternalCheckoutCtrl.OnWebViewFireEvent = OnWebViewFireEvent
return UIExternalCheckoutCtrl
