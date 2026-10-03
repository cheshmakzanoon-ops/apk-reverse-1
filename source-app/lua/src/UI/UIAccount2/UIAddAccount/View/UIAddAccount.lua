local UIAddAccount = BaseClass("UIAddAccount", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local OptionData = CS.UnityEngine.UI.Dropdown.OptionData

local function OnCreate(self)
  base.OnCreate(self)
  self.dialogTitle, self.isLoadingLogin = self:GetUserData()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.panel = self:AddComponent(UIButton, "UIAccountPopUpTitle/panel")
  self.textTitle = self:AddComponent(UIText, "UIAccountPopUpTitle/titleText")
  self.textTitleAccount = self:AddComponent(UIText, "Root/InputFieldMail/TextTitleMail")
  self.textPlaceHolder1 = self:AddComponent(UIText, "Root/InputFieldMail/TextPlaceholder1")
  self.textBtnLogin = self:AddComponent(UIText, "Root/BtnLogin/TextLogin")
  self.btnClose = self:AddComponent(UIButton, "UIAccountPopUpTitle/CloseBtn")
  self.btnLogin = self:AddComponent(UIButton, "Root/BtnLogin")
  self.dropdown = self:AddComponent(UIDropdown, "Root/Dropdown")
  self.inputAccount = self:AddComponent(UIInput, "Root/InputFieldMail")
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.panel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btnLogin:SetOnClick(BindCallback(self, self.OnBtnLoginClick))
  self.dropdown:SetOnValueChanged(function()
    self:OnValueChange()
  end)
  self.textTitle:SetLocalText(self.dialogTitle)
  self.textTitleAccount:SetLocalText(280039)
  self.textPlaceHolder1:SetLocalText(280102)
  self.textBtnLogin:SetLocalText(110008)
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.textTitleAccount = nil
  self.textPlaceHolder1 = nil
  self.textBtnLogin = nil
  self.btnClose = nil
  self.btnLogin = nil
  self.dropdown = nil
  self.inputAccount = nil
end

local function OnOpen(self)
  self:ShowAccount()
end

local function OnBtnLoginClick(self)
  local mail = self.inputAccount:GetText()
  if mail == nil or mail == "" then
    UIUtil.ShowTipsId(280122)
    return
  end
  local regex = "^[%w%._%-%+]+@[%w%._%-%+]+%a$"
  if not mail:match(regex) then
    UIUtil.ShowTipsId(280112)
    return
  end
  local account = DataCenter.AccountManager.MailAccount.gameAccount
  if not self.isLoadingLogin and account == mail then
    UIUtil.ShowTipsId(208214)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.AccountLoginSendVerifyCode, {mail = mail})
end

local function ShowAccount(self)
  self.dropdown:Clear()
  local list = DataCenter.AccountManager:GetAllAccount()
  local one = ""
  for k, v in pairs(list) do
    local temp = OptionData()
    temp.text = k
    self.dropdown:Add(temp)
    if one == "" then
      one = k
    end
  end
  self.dropdown:SetText(one)
  self.inputAccount:SetText(one)
  self.dropdown:SetValue(0)
end

local function OnValueChange(self)
  self.inputAccount:SetText(self.dropdown:GetText())
end

local function SetAccount(self, mail)
  self.inputAccount:SetText(mail)
end

UIAddAccount.OnCreate = OnCreate
UIAddAccount.OnDestroy = OnDestroy
UIAddAccount.ComponentDefine = ComponentDefine
UIAddAccount.ComponentDestroy = ComponentDestroy
UIAddAccount.OnOpen = OnOpen
UIAddAccount.OnBtnLoginClick = OnBtnLoginClick
UIAddAccount.ShowAccount = ShowAccount
UIAddAccount.OnValueChange = OnValueChange
UIAddAccount.SetAccount = SetAccount
return UIAddAccount
