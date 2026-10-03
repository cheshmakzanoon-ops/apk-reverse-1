local UIPinSetView = BaseClass("UIPinSetView", UIBaseView)
local base = UIBaseView
local return_btn_path = "Panel"
local close_btn_path = "ImgBg/BtnClose"
local title_path = "ImgBg/TxtTitle"
local change_btn_path = "ImgBg/ChangeBtn"
local change_btn_name_path = "ImgBg/ChangeBtn/ChangeBtnName"
local use_btn_path = "ImgBg/UseBtn"
local use_btn_name_path = "ImgBg/UseBtn/UseBtnName"
local forget_btn_path = "ImgBg/ForgetBtn"
local forget_btn_name_path = "ImgBg/ForgetBtn/ForgetBtnName"

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
  self.title = self:AddComponent(UIText, title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.change_btn = self:AddComponent(UIButton, change_btn_path)
  self.change_btn_name = self:AddComponent(UIText, change_btn_name_path)
  self.forget_btn = self:AddComponent(UIButton, forget_btn_path)
  self.forget_btn_name = self:AddComponent(UIText, forget_btn_name_path)
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.use_btn_name = self:AddComponent(UIText, use_btn_name_path)
  self.use_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnUseBtnClick()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.forget_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnForgetBtnClick()
  end)
  self.change_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnChangeBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.close_btn = nil
  self.return_btn = nil
  self.change_btn = nil
  self.change_btn_name = nil
  self.forget_btn = nil
  self.forget_btn_name = nil
  self.use_btn = nil
  self.use_btn_name = nil
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
  self.change_btn_name:SetLocalText(280084)
  self.use_btn_name:SetLocalText(280085)
  self.forget_btn_name:SetLocalText(280086)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.PinInputClose, self.PinInputCloseSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.PinInputClose, self.PinInputCloseSignal)
end

local function OnUseBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPinUseSet, {anim = true})
end

local function OnForgetBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPinForget, {anim = true})
end

local function OnChangeBtnClick(self)
  if LuaEntry.Player.pinPwdStatus == PinPwdStatus.Have then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPinInput, {anim = true}, UIPinInputType.Change)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPinInput, {anim = true}, UIPinInputType.Set)
  end
end

local function PinInputCloseSignal(self)
  self.ctrl:CloseSelf()
end

UIPinSetView.OnCreate = OnCreate
UIPinSetView.OnDestroy = OnDestroy
UIPinSetView.OnEnable = OnEnable
UIPinSetView.OnDisable = OnDisable
UIPinSetView.ComponentDefine = ComponentDefine
UIPinSetView.ComponentDestroy = ComponentDestroy
UIPinSetView.DataDefine = DataDefine
UIPinSetView.DataDestroy = DataDestroy
UIPinSetView.ReInit = ReInit
UIPinSetView.OnAddListener = OnAddListener
UIPinSetView.OnRemoveListener = OnRemoveListener
UIPinSetView.OnChangeBtnClick = OnChangeBtnClick
UIPinSetView.OnUseBtnClick = OnUseBtnClick
UIPinSetView.OnForgetBtnClick = OnForgetBtnClick
UIPinSetView.PinInputCloseSignal = PinInputCloseSignal
return UIPinSetView
