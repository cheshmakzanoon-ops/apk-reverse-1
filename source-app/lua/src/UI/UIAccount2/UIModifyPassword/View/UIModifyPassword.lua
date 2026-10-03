local UIModifyPassword = BaseClass("UIModifyPassword", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

local function OnCreate(self)
  base.OnCreate(self)
  local mail, code, tipsNew = self:GetUserData()
  self.mail = mail or false
  self.code = code or 0
  self.tipsNew = tipsNew or false
  self:ComponentDefine()
  self:OnOpen()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.textTitle = self:AddComponent(UIText, "Root/TextTitle")
  self.textTitlePwd = self:AddComponent(UIText, "Root/InputFieldPwd/TextTitlePwd")
  self.textPlaceHolder = self:AddComponent(UIText, "Root/InputFieldPwd/TextPlaceholder")
  self.textPwdInvalidTip = self:AddComponent(UIText, "Root/InputFieldPwd/TextPwdInvalidTip")
  self.btnClose = self:AddComponent(UIButton, "Root/BtnClose")
  self.btnForget = self:AddComponent(UIButton, "Root/BtnRect/BtnForgetPwd")
  self.btnSure = self:AddComponent(UIButton, "Root/BtnRect/BtnSure")
  self._sure_txt = self:AddComponent(UIText, "Root/BtnRect/BtnSure/TextSure")
  self._forget_txt = self:AddComponent(UIText, "Root/BtnRect/BtnForgetPwd/TextForgetPwd")
  self.inputPwd = self:AddComponent(UIInput, "Root/InputFieldPwd")
  self.textTitleEmail = self:AddComponent(UIText, "Root/TextTitleEmail")
  self.textTitleValue = self:AddComponent(UIText, "Root/TextTitleEmail/TextTitleValue")
  self.NewPwd = self:AddComponent(UIBaseContainer, "Root/NewPwd")
  self.inputFieldPwd1 = self:AddComponent(UIInput, "Root/NewPwd/InputFieldPwd1")
  self.textTitlePwd1 = self:AddComponent(UIText, "Root/NewPwd/InputFieldPwd1/TextTitlePwd1")
  self.textPwd1InvalidTip = self:AddComponent(UIText, "Root/NewPwd/InputFieldPwd1/TextPwd1InvalidTip")
  self.textPlaceHolder1 = self:AddComponent(UIText, "Root/NewPwd/InputFieldPwd1/TextPlaceholder1")
  self.imgFiled1 = self:AddComponent(UIText, "Root/NewPwd/InputFieldPwd1/ImgField1")
  self.inputFieldPwd2 = self:AddComponent(UIInput, "Root/NewPwd/InputFieldPwd2")
  self.textTitlePwd2 = self:AddComponent(UIText, "Root/NewPwd/InputFieldPwd2/TextTitlePwd2")
  self.textPwd2InvalidTip = self:AddComponent(UIText, "Root/NewPwd/InputFieldPwd2/TextPwd2InvalidTip")
  self.textPlaceHolder2 = self:AddComponent(UIText, "Root/NewPwd/InputFieldPwd2/TextPlaceholder2")
  self.imgFiled2 = self:AddComponent(UIText, "Root/NewPwd/InputFieldPwd2/ImgField2")
  self.btnGoBack = self:AddComponent(UIButton, "Root/Btn_GoBack")
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.Close))
  self.btnForget:SetOnClick(BindCallback(self, self.OnBtnForgetPwdClick))
  self.btnSure:SetOnClick(BindCallback(self, self.OnBtnGoModifyClick))
  self.inputPwd:SetOnValueChange(BindCallback(self, self.OnInputPwdEnd))
  self.btnGoBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.inputFieldPwd1:SetOnValueChange(BindCallback(self, self.OnInputPwd1End))
  self.inputFieldPwd2:SetOnValueChange(BindCallback(self, self.OnInputPwd2End))
  self.textTitleEmail:SetLocalText(208189)
  local account = DataCenter.AccountManager.MailAccount.gameAccount
  self.textTitleValue:SetText(self.mail and self.mail or account)
  self.textTitle:SetLocalText(280142)
  self.textTitlePwd:SetLocalText(208198)
  self.textPlaceHolder:SetLocalText(280104)
  self._sure_txt:SetLocalText(110006)
  self._forget_txt:SetLocalText(208199)
  self.textTitlePwd1:SetText(Localization:GetString("208201") .. Localization:GetString("208203"))
  self.textPlaceHolder1:SetLocalText(280104)
  self.textTitlePwd2:SetText(Localization:GetString("208202") .. Localization:GetString("208203"))
  self.textPlaceHolder2:SetLocalText(280104)
  self.isNewPwd = self.tipsNew
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.textTitlePwd = nil
  self.textPlaceHolder = nil
  self.textTitleEmail = nil
  self.textTitleValue = nil
  self.btnClose = nil
  self.btnForget = nil
  self._sure_txt = nil
  self._forget_txt = nil
  self.inputPwd:SetText("")
  self.inputPwd = nil
  self.inputFieldPwd1:SetText("")
  self.inputFieldPwd1 = nil
  self.inputFieldPwd2:SetText("")
  self.inputFieldPwd2 = nil
  self.imgFiled1 = nil
  self.imgFiled2 = nil
  self.isNewPwd = nil
  self.mail = nil
  self.code = nil
  self.tipsNew = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.CheckAccountPwdSuccess, self.ShowAccount)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CheckAccountPwdSuccess, self.ShowAccount)
end

local function OnOpen(self)
  self.textPwdInvalidTip:SetActive(false)
  self.inputPwd:SetActive(not self.tipsNew)
  self.NewPwd:SetActive(self.tipsNew)
  self.btnForget:SetActive(not self.tipsNew)
  self.imgFiled1:SetActive(false)
  self.imgFiled2:SetActive(false)
end

local function OnBtnForgetPwdClick(self)
  local account = DataCenter.AccountManager.MailAccount.gameAccount
  SFSNetwork.SendMessage(MsgDefines.AccountForgetPassword, account)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountVerify, account, 3)
end

local function ShowAccount(self)
  self.btnForget:SetActive(false)
  self.inputPwd:SetActive(false)
  self.NewPwd:SetActive(true)
  self.isNewPwd = true
end

local function OnBtnGoModifyClick(self)
  if not self.isNewPwd then
    SFSNetwork.SendMessage(MsgDefines.CheckAccountPassword, self.inputPwd:GetText())
    return
  end
  if self.isNewPwd then
    local password = self.inputFieldPwd1:GetText()
    local confirm = self.inputFieldPwd2:GetText()
    if not self.ctrl:CheckPwd(password, confirm) then
      return
    end
    if self.tipsNew then
      SFSNetwork.SendMessage(MsgDefines.AccountResetPassword, {
        mail = self.mail,
        verifyCode = self.code,
        pwd = password,
        confirmpwd = confirm
      })
    else
      local account = DataCenter.AccountManager.MailAccount.gameAccount
      SFSNetwork.SendMessage(MsgDefines.AccountChangePassword, self.mail and self.mail or account, {
        oldpwd = self.inputPwd:GetText(),
        pwd = password,
        confirmpwd = confirm
      })
    end
    self.ctrl:CloseSelf()
    return
  end
end

local function OnInputPwdEnd(self, value)
  if value == "" then
    return
  end
  local len = string.len(value)
  if len < 8 or 15 < len then
    self.textPwdInvalidTip:SetLocalText(280116)
    self.textPwdInvalidTip:SetActive(true)
    return
  end
  self.textPwdInvalidTip:SetText("")
  self.textPwdInvalidTip:SetActive(false)
end

local function OnInputPwd1End(self, value)
  self.imgFiled1:SetActive(false)
  if value == "" then
    return
  end
  local len = string.len(value)
  if len < 8 or 15 < len then
    self.textPwd1InvalidTip:SetLocalText(280116)
    self.textPwd1InvalidTip:SetActive(true)
    return
  end
  self.imgFiled1:SetActive(true)
  self.textPwd1InvalidTip:SetText("")
  self.textPwd1InvalidTip:SetActive(false)
end

local function OnInputPwd2End(self, value)
  self.imgFiled2:SetActive(false)
  if value == "" then
    return
  end
  local password = self.inputFieldPwd1:GetText()
  local len = string.len(value)
  if len < 8 or 15 < len then
    self.textPwd2InvalidTip:SetLocalText(280116)
    self.textPwd2InvalidTip:SetActive(true)
    return
  end
  if value ~= password then
    self.textPwd2InvalidTip:SetLocalText(280126)
    self.textPwd2InvalidTip:SetActive(true)
    return
  end
  self.imgFiled2:SetActive(true)
  self.textPwd2InvalidTip:SetText("")
  self.textPwd2InvalidTip:SetActive(false)
end

UIModifyPassword.OnCreate = OnCreate
UIModifyPassword.OnDestroy = OnDestroy
UIModifyPassword.ComponentDefine = ComponentDefine
UIModifyPassword.ComponentDestroy = ComponentDestroy
UIModifyPassword.OnAddListener = OnAddListener
UIModifyPassword.OnRemoveListener = OnRemoveListener
UIModifyPassword.OnOpen = OnOpen
UIModifyPassword.OnBtnForgetPwdClick = OnBtnForgetPwdClick
UIModifyPassword.ShowAccount = ShowAccount
UIModifyPassword.OnBtnGoModifyClick = OnBtnGoModifyClick
UIModifyPassword.OnInputPwdEnd = OnInputPwdEnd
UIModifyPassword.OnInputPwd1End = OnInputPwd1End
UIModifyPassword.OnInputPwd2End = OnInputPwd2End
return UIModifyPassword
