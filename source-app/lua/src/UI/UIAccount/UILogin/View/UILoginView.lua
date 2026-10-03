local UILoginView = BaseClass("UILoginView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local OptionData = CS.UnityEngine.UI.Dropdown.OptionData
local txt_title_path = "ImgBg/TxtTitle"
local close_btn_path = "ImgBg/BtnClose"
local return_btn_path = "Panel"
local confirm_btn_path = "ImgBg/ConfirmBtn"
local confirm_btn_name_path = "ImgBg/ConfirmBtn/ConfirmBtnName"
local username_input_path = "ImgBg/InputFieldUsername"
local username_text_path = "ImgBg/InputFieldUsername/UsernameText"
local username_hold_text_path = "ImgBg/InputFieldUsername/UsernamePlaceholder"
local password_input_path = "ImgBg/InputFieldPassword"
local password_text_path = "ImgBg/InputFieldPassword/PasswordText"
local password_hold_text_path = "ImgBg/InputFieldPassword/PasswordPlaceholder"
local dropdown_path = "ImgBg/Dropdown"

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
  self.username_input = self:AddComponent(UIInput, username_input_path)
  self.username_text = self:AddComponent(UIText, username_text_path)
  self.username_hold_text = self:AddComponent(UIText, username_hold_text_path)
  self.password_input = self:AddComponent(UIInput, password_input_path)
  self.password_text = self:AddComponent(UIText, password_text_path)
  self.password_hold_text = self:AddComponent(UIText, password_hold_text_path)
  self.dropdown = self:AddComponent(UIDropdown, dropdown_path)
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
  self.dropdown:SetOnValueChanged(function()
    self:OnValueChange()
  end)
end

local function ComponentDestroy(self)
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.confirm_btn = nil
  self.confirm_btn_name = nil
  self.username_input = nil
  self.username_text = nil
  self.username_hold_text = nil
  self.password_input = nil
  self.password_text = nil
  self.password_hold_text = nil
  self.dropdown = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.txt_title:SetLocalText(110008)
  self.username_text:SetLocalText(280039)
  self.password_text:SetLocalText(280103)
  self.confirm_btn_name:SetLocalText(280108)
  self.username_hold_text:SetLocalText(280102)
  self.password_hold_text:SetLocalText(280104)
  self:ShowAccount()
end

local function ShowAccount(self)
  self.dropdown:Clear()
  local list = DataCenter.AccountManager:GetAllAccount()
  local one = ""
  for k, v in pairs(list) do
    local temp = OptionData()
    temp.text = k
    self.dropdown:Add(temp)
    one = k
  end
  self.dropdown:SetText(one)
  self.username_input:SetText(one)
end

local function OnConfirmBtnClick(self)
  local username = self.username_input:GetText()
  local password = self.password_input:GetText()
  if username == nil or username == "" then
    UIUtil.ShowTipsId(280122)
  elseif self.ctrl:CheckPwd(password) then
    SFSNetwork.SendMessage(MsgDefines.AccountLogin, {userName = username, pwd = password})
    self.ctrl:CloseSelf()
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnValueChange(self)
  self.username_input:SetText(self.dropdown:GetText())
end

UILoginView.OnCreate = OnCreate
UILoginView.OnDestroy = OnDestroy
UILoginView.OnEnable = OnEnable
UILoginView.OnDisable = OnDisable
UILoginView.ComponentDefine = ComponentDefine
UILoginView.ComponentDestroy = ComponentDestroy
UILoginView.OnConfirmBtnClick = OnConfirmBtnClick
UILoginView.ReInit = ReInit
UILoginView.OnAddListener = OnAddListener
UILoginView.OnRemoveListener = OnRemoveListener
UILoginView.OnValueChange = OnValueChange
UILoginView.ShowAccount = ShowAccount
return UILoginView
