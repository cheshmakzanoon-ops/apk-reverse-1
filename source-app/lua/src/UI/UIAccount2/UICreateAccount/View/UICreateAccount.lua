local UICreateAccount = BaseClass("UICreateAccount", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  local panelType = self:GetUserData()
  self.panelType = panelType or 1
  if self.panelType == 1 then
    self.textTitle:SetLocalText(280101)
  elseif self.panelType == 2 then
    self.textTitle:SetLocalText("email_bind_new_title")
  end
  if self.panelType == 1 then
    self.textTip1:SetLocalText(280113)
  elseif self.panelType == 2 then
    self.textTip1:SetLocalText("email_bind_new_des2")
  end
end

local function ComponentDefine(self)
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.textTip1 = self:AddComponent(UIText, "Root/TextTopTip")
  self.textTitleMail = self:AddComponent(UIText, "Root/InputFieldMail/TextTitleMail")
  self.textPlaceHolder1 = self:AddComponent(UIText, "Root/InputFieldMail/TextPlaceholder1")
  self.textBtnSubmit = self:AddComponent(UIText, "Root/BtnSubmit/TextSubmit")
  self.textMailInvalidTip = self:AddComponent(UIText, "Root/InputFieldMail/TextMailInvalidTip")
  self.textSuffixInvalidTip = self:AddComponent(UIText, "Root/InputFieldSuffix/TextSuffixInvalidTip")
  self.inputFieldMail = self:AddComponent(UIInput, "Root/InputFieldMail")
  self.inputFieldSuffix = self:AddComponent(UIInput, "Root/InputFieldSuffix")
  self.textPlaceHolder2 = self:AddComponent(UIText, "Root/InputFieldSuffix/TextPlaceholder2")
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.btnSubmit = self:AddComponent(UIButton, "Root/BtnSubmit")
  self.textTitle:SetLocalText(280101)
  self.textTitleMail:SetLocalText(280039)
  self.textPlaceHolder1:SetLocalText(280102)
  self.textPlaceHolder2:SetLocalText(208215)
  self.textBtnSubmit:SetLocalText(280108)
  self.inputFieldSuffix:SetLocalText(208215)
  self.textMailInvalidTip:SetActive(false)
  self.textSuffixInvalidTip:SetActive(false)
  self.btnClose:SetOnClick(BindCallback(self, self.OnBtnClose))
  self.btnSubmit:SetOnClick(BindCallback(self, self.OnBtnSubmitClick))
  self.inputFieldMail:SetOnValueChange(BindCallback(self, self.OnInputMailEnd))
  self.inputFieldSuffix:SetOnValueChange(BindCallback(self, self.OnInputSuffixEnd))
  UIGray.SetGray(self.btnSubmit.transform, false, true)
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.textTip1 = nil
  self.textTitleMail = nil
  self.textPlaceHolder1 = nil
  self.textPlaceHolder2 = nil
  self.textBtnSubmit = nil
  self.inputFieldMail:SetText("")
  self.textMailInvalidTip:SetActive(false)
  self.textSuffixInvalidTip:SetActive(false)
  self.inputFieldMail = nil
  self.inputFieldSuffix:SetText("")
  self.inputFieldSuffix = nil
  self.btnClose = nil
  self.btnSubmit = nil
  self.inputMailEndText = nil
end

local function OnInputMailEnd(self, value)
  local username = value
  if username == nil or username == "" then
    self.textMailInvalidTip:SetLocalText(280112)
    self.textMailInvalidTip:SetActive(true)
    return
  end
  local regex = "^[%w%._%-%+]"
  if not username:match(regex) then
    self.textMailInvalidTip:SetLocalText(280112)
    self.textMailInvalidTip:SetActive(true)
    return
  end
  self.textMailInvalidTip:SetText("")
  self.textMailInvalidTip:SetActive(false)
  self.inputMailEndText = username
end

local function OnInputSuffixEnd(self, value)
  local suffix = value
  if suffix == nil or suffix == "" then
    self.textSuffixInvalidTip:SetLocalText(280112)
    self.textSuffixInvalidTip:SetActive(true)
    return
  end
  local regex = "@[%w%._%-%+]+%a$"
  if not suffix:match(regex) then
    self.textSuffixInvalidTip:SetLocalText(280112)
    self.textSuffixInvalidTip:SetActive(true)
    return
  end
  self.textSuffixInvalidTip:SetText("")
  self.textSuffixInvalidTip:SetActive(false)
end

local function OnBtnSubmitClick(self)
  local name = self.inputFieldMail:GetText()
  local suffix = self.inputFieldSuffix:GetText()
  if name == nil or name == "" then
    UIUtil.ShowTipsId(280112)
    return
  end
  if suffix == "" then
    suffix = Localization:GetString("208215")
  end
  local username = name .. suffix
  local regex = "^[%w%._%-%+]+@[%w%._%-%+]+%a$"
  if not username:match(regex) then
    UIUtil.ShowTipsId(280112)
    return
  end
  if self.panelType == 1 then
    SFSNetwork.SendMessage(MsgDefines.AccountBind, {userName = username})
  elseif self.panelType == 2 then
    SFSNetwork.SendMessage(MsgDefines.ChangeBindAccountEmail, {changeType = 2, newMail = username})
  end
end

local function OnBtnClose(self)
  if DataCenter.AccountManager:GetIsBindingNewAccount() then
    UIUtil.ShowMessage(Localization:GetString("email_bind_cancel_des"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self.ctrl:CloseSelf()
    end, nil, nil, "email_bind_cancel_title")
  else
    self.ctrl:CloseSelf()
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AccountBindEvent, self.AccountBindSignal)
  self:AddUIListener(EventId.AccountChangePwdEvent, self.AccountChangePwdSignal)
  self:AddUIListener(EventId.AccountChangeEvent, self.AccountChangeSignal)
  self:AddUIListener(EventId.CreateAccountMailFail, self.MailFailSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AccountBindEvent, self.AccountBindSignal)
  self:RemoveUIListener(EventId.AccountChangePwdEvent, self.AccountChangePwdSignal)
  self:RemoveUIListener(EventId.AccountChangeEvent, self.AccountChangeSignal)
  self:RemoveUIListener(EventId.CreateAccountMailFail, self.MailFailSignal)
end

local function AccountBindSignal(self)
  self.ctrl:CloseSelf()
end

local function AccountChangePwdSignal(self)
  self.ctrl:CloseSelf()
end

local function AccountChangeSignal(self)
  self.ctrl:CloseSelf()
end

local function MailFailSignal(self)
  UIGray.SetGray(self.btnSubmit.transform, false, true)
end

UICreateAccount.OnCreate = OnCreate
UICreateAccount.OnDestroy = OnDestroy
UICreateAccount.OnEnable = OnEnable
UICreateAccount.ComponentDefine = ComponentDefine
UICreateAccount.ComponentDestroy = ComponentDestroy
UICreateAccount.OnAddListener = OnAddListener
UICreateAccount.OnRemoveListener = OnRemoveListener
UICreateAccount.AccountBindSignal = AccountBindSignal
UICreateAccount.AccountChangePwdSignal = AccountChangePwdSignal
UICreateAccount.AccountChangeSignal = AccountChangeSignal
UICreateAccount.MailFailSignal = MailFailSignal
UICreateAccount.OnInputMailEnd = OnInputMailEnd
UICreateAccount.OnInputSuffixEnd = OnInputSuffixEnd
UICreateAccount.OnBtnSubmitClick = OnBtnSubmitClick
UICreateAccount.OnBtnClose = OnBtnClose
return UICreateAccount
