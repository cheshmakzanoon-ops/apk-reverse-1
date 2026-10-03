local base = UIBaseContainer
local UIWebViewContent = BaseClass("UIWebViewContent", base)
local compBook = {
  {
    path = "bottom/webBtnBack",
    name = "webBtnBack",
    type = UIButton,
    onClick = function(self)
      self:OnClickBack()
    end
  },
  {
    path = "webView",
    name = "webView",
    type = UIBaseContainer
  }
}

function UIWebViewContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIWebViewContent:OnDestroy()
  if self.isActive then
    self:CloseWeb()
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWebViewContent:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIWebViewContent:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIWebViewContent:InitData(openFunc, closeFunc, openType)
  self:SetActive(false)
  self.openFunc = openFunc
  self.closeFunc = closeFunc
  self.openType = openType
end

function UIWebViewContent:OnOpenURL(data)
  if CS.SDKManager.IS_UNITY_EDITOR() or Config.IsPC() then
    CS.SDKManager.OpenURL(data.openUrl)
  else
    if self.openFunc then
      self.openFunc()
    end
    self:SetActive(true)
    DataCenter.LWNewsCenterManager:ShowWebViewURl({
      obj = self.webView.gameObject,
      url = data.openUrl,
      startJson = data.eventJson,
      openType = self.openType
    })
  end
end

function UIWebViewContent:OnClickBack()
  local isCanCloseView = not CS.ZendeskSupportView.WebViewBack()
  if isCanCloseView then
    self:CloseWeb()
  end
end

function UIWebViewContent:CloseWeb()
  if self.closeFunc then
    self.closeFunc()
  end
  self:SetActive(false)
  CS.ZendeskSupportView.Close()
end

return UIWebViewContent
