local UIAccountVerify = BaseClass("UIAccountVerify", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local OptionData = CS.UnityEngine.UI.Dropdown.OptionData
local VERIFY_CODE_LEN = 6

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.TextTip1 = self:AddComponent(UIText, "Root/TextTip1")
  self.TextTip2 = self:AddComponent(UIText, "Root/TextTip2")
  self.textBtnSubmit = self:AddComponent(UIText, "Root/BtnRect/BtnSubmit/TextSubmit")
  self.textChangeMail = self:AddComponent(UIText, "Root/BtnRect/BtnChangeMail/TextChangeMail")
  self.textResend = self:AddComponent(UIText, "Root/TextResend")
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.btnSubmit = self:AddComponent(UIButton, "Root/BtnRect/BtnSubmit")
  self.btnChangeMail = self:AddComponent(UIButton, "Root/BtnRect/BtnChangeMail")
  self.btnResend = self:AddComponent(UIButton, "Root/ResendBtn")
  self.btnGoBack = self:AddComponent(UIButton, "Root/Btn_GoBack")
  self.inputField = self:AddComponent(UIInput, "Root/InputField")
  self.btnClose:SetOnClick(BindCallback(self, self.OnBtnClose))
  self.btnSubmit:SetOnClick(BindCallback(self, self.OnBtnSubmitClick))
  self.btnChangeMail:SetOnClick(BindCallback(self, self.OnBtnChangeMailClick))
  self.btnResend:SetOnClick(BindCallback(self, self.OnBtnResendClick))
  self.btnGoBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.boxTexts = {}
  for k = 1, VERIFY_CODE_LEN do
    local textBox = self:AddComponent(UIText, "Root/NodeVerifyBox/Box" .. k .. "/Text" .. k)
    table.insert(self.boxTexts, textBox)
  end
  self.textTitle:SetLocalText(280109)
  self.TextTip1:SetLocalText(208190)
  self.textBtnSubmit:SetLocalText(280108)
  self.textChangeMail:SetLocalText(208197)
  self.inputField:SetOnValueChange(BindCallback(self, self.OnValueChange))
  if self.resendTimer == nil then
    self.resendTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
    self.resendTimer:Start()
    self:OnUpdateSec()
  end
end

local function ComponentDestroy(self)
  if self.resendTimer then
    self.resendTimer:Stop()
    self.resendTimer = nil
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  local mail, verifyType = self:GetUserData()
  self.mail = mail or ""
  self.verifyType = verifyType
  self.openTime = UITimeManager:GetInstance():GetServerTime()
  if self.verifyType == 1 then
    self.TextTip2:SetLocalText(208209, mail)
  elseif self.verifyType == 2 then
    self.TextTip2:SetLocalText(208191, mail)
  elseif self.verifyType == 3 then
    self.TextTip2:SetLocalText(208205, mail)
  elseif self.verifyType == 4 then
    self.TextTip2:SetText(Localization:GetString("email_bind_new_des1", mail))
  elseif self.verifyType == 5 then
    self.TextTip2:SetLocalText(208205, mail)
  elseif self.verifyType == 6 then
    self.TextTip2:SetLocalText(208209, mail)
  end
  self.TextTip1:SetActive(verifyType ~= 3 and verifyType ~= 4 and verifyType ~= 6)
  self.btnChangeMail:SetActive(verifyType == 2 or verifyType == 5)
  self.inputField:SetText("")
end

local function OnBtnSubmitClick(self)
  local code = self.inputField:GetText()
  if code == nil or code == "" or string.len(code) < 6 then
    return
  end
  if self.verifyType == 1 then
    SFSNetwork.SendMessage(MsgDefines.AccountLoginNew, {
      mail = self.mail,
      code = code
    })
  elseif self.verifyType == 2 then
    SFSNetwork.SendMessage(MsgDefines.AccountVerify, code)
  elseif self.verifyType == 3 then
    SFSNetwork.SendMessage(MsgDefines.CheckAccountMailVerifyCode, {
      mail = self.mail,
      code = code
    })
  elseif self.verifyType == 4 then
    SFSNetwork.SendMessage(MsgDefines.VerifyBindAccountEmail, {changeType = 1, oldVerifyCode = code})
    DataCenter.AccountManager:SetOldEmailVerifyCode(code)
  elseif self.verifyType == 5 then
    local oldVerifyCode = DataCenter.AccountManager:GetOldEmailVerifyCode()
    SFSNetwork.SendMessage(MsgDefines.VerifyBindAccountEmail, {
      changeType = 2,
      oldVerifyCode = oldVerifyCode,
      newVerifyCode = code
    })
  elseif self.verifyType == 6 then
    SFSNetwork.SendMessage(MsgDefines.CheckDeviceMailVerifyCode, {
      mail = self.mail,
      code = code
    })
  end
end

local function OnBtnChangeMailClick(self)
  self.ctrl:CloseSelf()
  if self.verifyType == 1 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAddAccount, 110008)
  elseif self.verifyType == 2 then
    DataCenter.AccountManager.MailAccount.gameAccount = ""
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICreateAccount, 1)
  elseif self.verifyType == 5 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICreateAccount, 2)
  elseif DataCenter.AccountScoreManager:CheckAccountIDOpen() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountManage)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingAccount)
  end
end

local function OnBtnClose(self)
  if DataCenter.AccountManager:GetIsBindingNewAccount() then
    UIUtil.ShowMessage(Localization:GetString("email_bind_cancel_des"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self.ctrl:CloseSelf()
    end, nil, nil, "email_bind_cancel_title")
  elseif self.verifyType == 6 or self.verifyType == 1 then
    self.ctrl:CloseSelf()
  else
    DataCenter.AccountManager.MailAccount.gameAccount = ""
    self.ctrl:CloseSelf()
  end
end

local function OnValueChange(self, value)
  local len = string.len(value)
  for k, v in ipairs(self.boxTexts) do
    v:SetText(k <= len and value:sub(k, k) or "")
  end
end

local function OnBtnResendClick(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  if now - self.openTime < 1200000 then
    UIUtil.ShowMessage(Localization:GetString("verify_resend_content"), 2, "280117", GameDialogDefine.CANCEL, function()
      self:ReallyResendVerifyCode()
    end, nil, nil)
  else
    self:ReallyResendVerifyCode()
  end
end

function UIAccountVerify:ReallyResendVerifyCode()
  local now = UITimeManager:GetInstance():GetServerTime()
  local cooldown = 300000
  local newExpireTime = now + cooldown
  Setting:SetPrivateString("LW_EmailResendExpireTime", tostring(newExpireTime))
  CS.UIGray.SetGray(self.btnResend.transform, true, false)
  if self.verifyType == 1 then
    SFSNetwork.SendMessage(MsgDefines.AccountLoginSendVerifyCode, {
      mail = self.mail
    })
  elseif self.verifyType == 2 then
    SFSNetwork.SendMessage(MsgDefines.AccountBind, {
      userName = self.mail
    })
  elseif self.verifyType == 4 then
    SFSNetwork.SendMessage(MsgDefines.ChangeBindAccountEmail, {changeType = 1})
  elseif self.verifyType == 5 then
    SFSNetwork.SendMessage(MsgDefines.ChangeBindAccountEmail, {
      changeType = 2,
      newMail = self.mail
    })
  elseif self.verifyType == 6 then
    local customType = DataCenter.AccountManager:GetMailVerifyCodeType()
    SFSNetwork.SendMessage(MsgDefines.AccountDeviceSendVerifyCode, {
      mail = self.mail,
      oType = customType
    })
  end
end

function UIAccountVerify:OnUpdateSec()
  local expireTime = Setting:GetPrivateString("LW_EmailResendExpireTime", "")
  if string.IsNullOrEmpty(expireTime) then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local eTime = tonumber(expireTime)
  if now > eTime then
    CS.UIGray.SetGray(self.btnResend.transform, false, true)
    self.textResend:SetLocalText("280117")
    self.textResend:SetColorRGBA255(236, 131, 29, 255)
    return
  end
  local leftTime = eTime - now
  leftTime = math.floor(leftTime / 1000)
  CS.UIGray.SetGray(self.btnResend.transform, true, false)
  local secTime = Localization:GetString("280117") .. string.format("(%ds)", leftTime)
  self.textResend:SetText(secTime)
  self.textResend:SetColorRGBA255(209, 44, 32, 255)
end

UIAccountVerify.OnCreate = OnCreate
UIAccountVerify.OnDestroy = OnDestroy
UIAccountVerify.OnEnable = OnEnable
UIAccountVerify.ComponentDefine = ComponentDefine
UIAccountVerify.ComponentDestroy = ComponentDestroy
UIAccountVerify.OnBtnSubmitClick = OnBtnSubmitClick
UIAccountVerify.OnBtnChangeMailClick = OnBtnChangeMailClick
UIAccountVerify.OnValueChange = OnValueChange
UIAccountVerify.OnBtnClose = OnBtnClose
UIAccountVerify.OnBtnResendClick = OnBtnResendClick
return UIAccountVerify
