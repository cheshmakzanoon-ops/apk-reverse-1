local UIBindAccountCreateView = BaseClass("UIBindAccountCreateView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "ImgBg/TxtTitle"
local close_btn_path = "ImgBg/BtnClose"
local return_btn_path = "Panel"
local confirm_btn_path = "ImgBg/ConfirmBtn"
local confirm_btn_name_path = "ImgBg/ConfirmBtn/ConfirmBtnName"
local tip_text_path = "ImgBg/TipText"
local username_input_path = "ImgBg/InputFieldUsername"
local username_text_path = "ImgBg/InputFieldUsername/UsernameText"
local username_hold_text_path = "ImgBg/InputFieldUsername/UsernamePlaceholder"
local password_input_path = "ImgBg/InputFieldPassword"
local password_text_path = "ImgBg/InputFieldPassword/PasswordText"
local password_hold_text_path = "ImgBg/InputFieldPassword/PasswordPlaceholder"
local confirm_password_input_path = "ImgBg/InputFieldConfirmPassword"
local confirm_password_text_path = "ImgBg/InputFieldConfirmPassword/ConfirmPasswordText"
local confirm_password_hold_text_path = "ImgBg/InputFieldConfirmPassword/ConfirmPasswordPlaceholder"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirm_btn_name = self:AddComponent(UIText, confirm_btn_name_path)
  self.tip_text = self:AddComponent(UIText, tip_text_path)
  self.username_input = self:AddComponent(UIInput, username_input_path)
  self.username_text = self:AddComponent(UIText, username_text_path)
  self.username_hold_text = self:AddComponent(UIText, username_hold_text_path)
  self.password_input = self:AddComponent(UIInput, password_input_path)
  self.password_text = self:AddComponent(UIText, password_text_path)
  self.password_hold_text = self:AddComponent(UIText, password_hold_text_path)
  self.confirm_password_input = self:AddComponent(UIInput, confirm_password_input_path)
  self.confirm_password_text = self:AddComponent(UIText, confirm_password_text_path)
  self.confirm_password_hold_text = self:AddComponent(UIText, confirm_password_hold_text_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.confirm_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnConfirmBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.confirm_btn = nil
  self.confirm_btn_name = nil
  self.tip_text = nil
  self.username_input = nil
  self.username_text = nil
  self.username_hold_text = nil
  self.password_input = nil
  self.password_text = nil
  self.password_hold_text = nil
  self.confirm_password_input = nil
  self.confirm_password_text = nil
  self.confirm_password_hold_text = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.createType = self:GetUserData()
  if self.createType == AccountCreateType.Register then
    self.txt_title:SetLocalText(280101)
  elseif self.createType == AccountCreateType.ChangePassword then
    self.txt_title:SetLocalText(280142)
  end
  self.tip_text:SetLocalText(280164)
  self.username_text:SetLocalText(280039)
  self.password_text:SetLocalText(280141)
  self.confirm_password_text:SetLocalText(280105)
  self.confirm_btn_name:SetLocalText(280108)
  self.username_hold_text:SetLocalText(280102)
  self.password_hold_text:SetLocalText(280104)
  self.confirm_password_hold_text:SetLocalText(280106)
end

local function OnConfirmBtnClick(self)
  local username = self.username_input:GetText()
  local password = self.password_input:GetText()
  local confirm = self.confirm_password_input:GetText()
  if username == nil or username == "" then
    UIUtil.ShowTipsId(280122)
  elseif self.ctrl:CheckPwd(password, confirm) then
    if self.createType == AccountCreateType.ChangePassword then
      local account = DataCenter.AccountManager.MailAccount.gameAccount
      if account ~= username then
        UIUtil.ShowTipsId(280144)
        return
      end
      SFSNetwork.SendMessage(MsgDefines.AccountChangePassword, {
        username = username,
        pwd = password,
        confirmPassword = confirm
      })
    elseif self.createType == AccountCreateType.Register then
      SFSNetwork.SendMessage(MsgDefines.AccountBind, {userName = username, pwd = password})
    end
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AccountBindEvent, self.AccountBindSignal)
  self:AddUIListener(EventId.AccountChangePwdEvent, self.AccountChangePwdSignal)
  self:AddUIListener(EventId.AccountChangeEvent, self.AccountChangeSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AccountBindEvent, self.AccountBindSignal)
  self:RemoveUIListener(EventId.AccountChangePwdEvent, self.AccountChangePwdSignal)
  self:RemoveUIListener(EventId.AccountChangeEvent, self.AccountChangeSignal)
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

UIBindAccountCreateView.OnCreate = OnCreate
UIBindAccountCreateView.OnDestroy = OnDestroy
UIBindAccountCreateView.OnEnable = OnEnable
UIBindAccountCreateView.OnDisable = OnDisable
UIBindAccountCreateView.ComponentDefine = ComponentDefine
UIBindAccountCreateView.ComponentDestroy = ComponentDestroy
UIBindAccountCreateView.OnConfirmBtnClick = OnConfirmBtnClick
UIBindAccountCreateView.ReInit = ReInit
UIBindAccountCreateView.OnAddListener = OnAddListener
UIBindAccountCreateView.OnRemoveListener = OnRemoveListener
UIBindAccountCreateView.AccountBindSignal = AccountBindSignal
UIBindAccountCreateView.AccountChangePwdSignal = AccountChangePwdSignal
UIBindAccountCreateView.AccountChangeSignal = AccountChangeSignal
return UIBindAccountCreateView
