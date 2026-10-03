local UIBindSuccess = BaseClass("UIBindSuccess", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:OnOpen()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function Close(self)
  if self.ctrl then
    self.ctrl.CloseSelf()
  end
  if self.closeCallBack then
    self.closeCallBack()
  end
end

local function ComponentDefine(self)
  self.textTitle = self:AddComponent(UIText, "UICommonMiniPopUpTitle/titleText")
  self.textTip1 = self:AddComponent(UIText, "Root/TextTips1")
  self.textTip2 = self:AddComponent(UIText, "Root/TextTips2")
  self.textTip3 = self:AddComponent(UIText, "Root/TextTips3")
  self.textBtnOk = self:AddComponent(UIText, "Root/BtnOk/TextOk")
  self.btnClose = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/CloseBtn")
  self.btnOk = self:AddComponent(UIButton, "Root/BtnOk")
  local close = BindCallback(self, Close)
  self.btnClose:SetOnClick(close)
  self.btnOk:SetOnClick(close)
  self.textTitle:SetLocalText(280053)
  self.textTip1:SetLocalText(280167)
  self.textTip2:SetLocalText(280168)
  self.textTip3:SetLocalText(280120)
  self.textBtnOk:SetLocalText(110006)
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.textTip1 = nil
  self.textTip2 = nil
  self.textTip3 = nil
  self.textBtnOk = nil
  self.btnClose = nil
  self.btnOk = nil
end

local function OnOpen(self)
  self.bindSuccessType, self.hasReward, self.closeCallBack = self:GetUserData()
  self.textTip3:SetActive(self.hasReward)
end

UIBindSuccess.OnCreate = OnCreate
UIBindSuccess.OnDestroy = OnDestroy
UIBindSuccess.ComponentDefine = ComponentDefine
UIBindSuccess.ComponentDestroy = ComponentDestroy
UIBindSuccess.OnOpen = OnOpen
return UIBindSuccess
