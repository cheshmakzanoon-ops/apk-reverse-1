local UIForgetPassword = BaseClass("UIForgetPassword", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:OnOpen()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.textTitle = self:AddComponent(UIText, "Root/TextTitle")
  self.textTitleAccount = self:AddComponent(UIText, "Root/InputFieldAccount/TextTitleAccount")
  self.textPlaceHolder1 = self:AddComponent(UIText, "Root/InputFieldAccount/TextPlaceholder1")
  self.textMailInvalidTip = self:AddComponent(UIText, "Root/InputFieldAccount/TextMailInvalidTip")
  self.textBtnReset = self:AddComponent(UIText, "Root/BtnResetPwd/TextResetPwd")
  self.btnClose = self:AddComponent(UIButton, "Root/BtnClose")
  self.btnReset = self:AddComponent(UIButton, "Root/BtnResetPwd")
  self.btnGoBack = self:AddComponent(UIButton, "Root/Btn_GoBack")
  self.inputAccount = self:AddComponent(UIInput, "Root/InputFieldAccount")
  self._des_txt = self:AddComponent(UIText, "Root/Txt_Des")
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.Close))
  self.btnReset:SetOnClick(BindCallback(self, self.OnBtnResetPwdClick))
  self.btnGoBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self._des_txt:SetLocalText(208206)
  self.textTitle:SetLocalText(208199)
  self.textTitleAccount:SetLocalText(280039)
  self.textPlaceHolder1:SetLocalText(280102)
  self.textBtnReset:SetLocalText(110006)
  self.inputAccount:SetOnValueChange(BindCallback(self, self.OnInputMailEnd))
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.textTitleAccount = nil
  self.textPlaceHolder1 = nil
  self._des_txt = nil
  self.textBtnReset = nil
  self.btnClose = nil
  self.btnReset = nil
  self.inputAccount = nil
  self.textMailInvalidTip = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AccountCheckSuccess, self.AccountCheckSuccess)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AccountCheckSuccess, self.AccountCheckSuccess)
end

local function OnOpen(self)
  self.inputAccount:SetText("")
  self.textMailInvalidTip:SetActive(false)
end

local function OnInputMailEnd(self, value)
  local username = value
  if username == nil or username == "" then
    self.textMailInvalidTip:SetLocalText(280112)
    self.textMailInvalidTip:SetActive(true)
    return
  end
  local regex = "^[%w%._%-%+]+@[%w%._%-%+]+%a$"
  if not username:match(regex) then
    self.textMailInvalidTip:SetLocalText(280112)
    self.textMailInvalidTip:SetActive(true)
    return
  end
  self.textMailInvalidTip:SetText("")
  self.textMailInvalidTip:SetActive(false)
end

local function OnBtnResetPwdClick(self)
  local username = self.inputAccount:GetText()
  local regex = "^[%w%._%-%+]+@[%w%._%-%+]+%a$"
  if username == nil or username == "" then
    UIUtil.ShowTipsId(280112)
    return
  elseif not username:match(regex) then
    self.textMailInvalidTip:SetLocalText(280112)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.AccountForgetPassword, self.inputAccount:GetText())
end

local function AccountCheckSuccess(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountVerify, self.inputAccount:GetText(), 3)
  self.ctrl:CloseSelf()
end

UIForgetPassword.OnCreate = OnCreate
UIForgetPassword.OnDestroy = OnDestroy
UIForgetPassword.ComponentDefine = ComponentDefine
UIForgetPassword.ComponentDestroy = ComponentDestroy
UIForgetPassword.OnAddListener = OnAddListener
UIForgetPassword.OnRemoveListener = OnRemoveListener
UIForgetPassword.OnOpen = OnOpen
UIForgetPassword.OnInputMailEnd = OnInputMailEnd
UIForgetPassword.OnBtnResetPwdClick = OnBtnResetPwdClick
UIForgetPassword.AccountCheckSuccess = AccountCheckSuccess
return UIForgetPassword
