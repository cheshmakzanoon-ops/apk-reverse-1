local UIPinForgetView = BaseClass("UIPinForgetView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "ImgBg/TxtTitle"
local close_btn_path = "ImgBg/BtnClose"
local return_btn_path = "Panel"
local des_path = "ImgBg/DecText"
local input_path = "ImgBg/InputField"
local send_btn_path = "ImgBg/ConfirmBtn"
local send_name_path = "ImgBg/ConfirmBtn/ConfirmBtnName"
local input_replace_path = "ImgBg/InputField/Placeholder"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.des = self:AddComponent(UIText, des_path)
  self.input = self:AddComponent(UIInput, input_path)
  self.send_btn = self:AddComponent(UIButton, send_btn_path)
  self.send_name = self:AddComponent(UIText, send_name_path)
  self.input_replace = self:AddComponent(UIText, input_replace_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.send_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnSendBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.des = nil
  self.input = nil
  self.send_btn = nil
  self.send_name = nil
  self.input_replace = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.txt_title:SetLocalText(280086)
  self.des:SetLocalText(280159)
  self.send_name:SetLocalText(GameDialogDefine.CONFIRM)
  self.input_replace:SetLocalText(280102)
  self.input:SetText("")
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnSendBtnClick(self)
  local temp = self.input:GetText()
  if temp ~= nil and temp ~= "" then
    UIUtil.ShowTipsId(280113)
  else
    SFSNetwork.SendMessage(MsgDefines.PinPwdForget, {email = temp})
    self.ctrl:CloseSelf()
  end
end

UIPinForgetView.OnCreate = OnCreate
UIPinForgetView.OnDestroy = OnDestroy
UIPinForgetView.OnEnable = OnEnable
UIPinForgetView.OnDisable = OnDisable
UIPinForgetView.OnAddListener = OnAddListener
UIPinForgetView.OnRemoveListener = OnRemoveListener
UIPinForgetView.ComponentDefine = ComponentDefine
UIPinForgetView.ComponentDestroy = ComponentDestroy
UIPinForgetView.DataDefine = DataDefine
UIPinForgetView.DataDestroy = DataDestroy
UIPinForgetView.ReInit = ReInit
UIPinForgetView.OnSendBtnClick = OnSendBtnClick
return UIPinForgetView
