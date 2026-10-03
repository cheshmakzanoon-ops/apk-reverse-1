local UIBindAccountAlreadyView = BaseClass("UIBindAccountAlreadyView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local txt_title_path = "ImgBg/TxtTitle"
local close_btn_path = "ImgBg/BtnClose"
local return_btn_path = "Panel"
local confirm_btn_path = "ImgBg/ConfirmBtn"
local confirm_btn_name_path = "ImgBg/ConfirmBtn/ConfirmBtnName"
local account_text_path = "ImgBg/AccountText"
local account_value_path = "ImgBg/AccountText/AccountValue"
local name_text_path = "ImgBg/NameText"
local name_value_path = "ImgBg/NameText/NameValue"
local state_text_path = "ImgBg/StateText"
local state_value_path = "ImgBg/StateText/StateValue"

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
  self.account_text = self:AddComponent(UIText, account_text_path)
  self.account_value = self:AddComponent(UIText, account_value_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.name_value = self:AddComponent(UIText, name_value_path)
  self.state_text = self:AddComponent(UIText, state_text_path)
  self.state_value = self:AddComponent(UIText, state_value_path)
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
  self.account_text = nil
  self.account_value = nil
  self.name_text = nil
  self.name_value = nil
  self.state_text = nil
  self.state_value = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.account_text:SetText(Localization:GetString("280039") .. ": ")
  self.name_text:SetText(Localization:GetString("100454") .. ": ")
  self.state_text:SetLocalText(280040)
  self.txt_title:SetLocalText(280101)
  self.confirm_btn_name:SetLocalText(280142)
  self.name_value:SetText(LuaEntry.Player.name)
  self.state_value:SetLocalText(280124)
  local account = DataCenter.AccountManager.MailAccount.gameAccount
  self.account_value:SetText(account)
end

local function OnConfirmBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBindAccountCreate, {anim = true}, AccountCreateType.ChangePassword)
  self.ctrl:CloseSelf()
end

UIBindAccountAlreadyView.OnCreate = OnCreate
UIBindAccountAlreadyView.OnDestroy = OnDestroy
UIBindAccountAlreadyView.OnEnable = OnEnable
UIBindAccountAlreadyView.OnDisable = OnDisable
UIBindAccountAlreadyView.ComponentDefine = ComponentDefine
UIBindAccountAlreadyView.ComponentDestroy = ComponentDestroy
UIBindAccountAlreadyView.OnConfirmBtnClick = OnConfirmBtnClick
UIBindAccountAlreadyView.ReInit = ReInit
return UIBindAccountAlreadyView
