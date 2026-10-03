local UIExternalCheckoutView = BaseClass("UIExternalCheckoutView", UIBaseView)
local base = UIBaseView

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
  self.btnBack = self:AddComponent(UIButton, "Root/BottomBar/BtnBack")
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.compContainer = self:AddComponent(UIBaseContainer, "Root/Middle/Container")
end

local function ComponentDestroy(self)
  self.btnBack = nil
  self.compContainer = nil
end

local function DataDefine(self)
  local param = self:GetUserData() or {}
  self.url = param.url
  self.ctrl:CreateExternalCheckoutView(self.compContainer, self.url)
end

local function DataDestroy(self)
  self.url = nil
  self.ctrl:CloseExternalCheckoutView()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.WEBVIEW_FIRE_EVENT, self.OnWebViewFireEvent)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.WEBVIEW_FIRE_EVENT, self.OnWebViewFireEvent)
  base.OnRemoveListener(self)
end

local function OnWebViewFireEvent(self, eventJson)
  self.ctrl:OnWebViewFireEvent(eventJson)
end

local function OnBtnBackClick(self)
  self.ctrl:CloseSelf()
end

UIExternalCheckoutView.OnCreate = OnCreate
UIExternalCheckoutView.OnDestroy = OnDestroy
UIExternalCheckoutView.OnEnable = OnEnable
UIExternalCheckoutView.OnDisable = OnDisable
UIExternalCheckoutView.ComponentDefine = ComponentDefine
UIExternalCheckoutView.ComponentDestroy = ComponentDestroy
UIExternalCheckoutView.DataDefine = DataDefine
UIExternalCheckoutView.DataDestroy = DataDestroy
UIExternalCheckoutView.OnAddListener = OnAddListener
UIExternalCheckoutView.OnRemoveListener = OnRemoveListener
UIExternalCheckoutView.OnWebViewFireEvent = OnWebViewFireEvent
UIExternalCheckoutView.OnBtnBackClick = OnBtnBackClick
return UIExternalCheckoutView
