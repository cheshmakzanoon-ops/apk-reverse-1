local UIPinUseSetView = BaseClass("UIPinUseSetView", UIBaseView)
local base = UIBaseView
local return_btn_path = "Panel"
local close_btn_path = "ImgBg/BtnClose"
local title_path = "ImgBg/TxtTitle"
local des_text_path = "ImgBg/DecText"
local slider_path = "ImgBg/Slider"
local btn_path = "ImgBg/Slider/Background"

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
  self.des_text = self:AddComponent(UIText, des_text_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.des_text = nil
  self.slider = nil
  self.btn = nil
end

local function DataDefine(self)
  self.state = nil
end

local function DataDestroy(self)
  self.state = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.title:SetLocalText(280085)
  self.des_text:SetLocalText(280088)
  if LuaEntry.Player.pinPwdCheckFrequency == UIPinOpenState.Open then
    self.state = UIPinOpenState.Open
  else
    self.state = UIPinOpenState.Close
  end
  self:RefreshState()
end

local function OnBtnClick(self)
  if self.state == UIPinOpenState.Close then
    self.state = UIPinOpenState.Open
  else
    self.state = UIPinOpenState.Close
  end
  self:RefreshState()
  SFSNetwork.SendMessage(MsgDefines.PinPwdCheckFrequency, {
    state = self.state
  })
end

local function RefreshState(self)
  if self.state == UIPinOpenState.Close then
    self.slider:SetValue(0)
  else
    self.slider:SetValue(1)
  end
end

UIPinUseSetView.OnCreate = OnCreate
UIPinUseSetView.OnDestroy = OnDestroy
UIPinUseSetView.OnEnable = OnEnable
UIPinUseSetView.OnDisable = OnDisable
UIPinUseSetView.ComponentDefine = ComponentDefine
UIPinUseSetView.ComponentDestroy = ComponentDestroy
UIPinUseSetView.DataDefine = DataDefine
UIPinUseSetView.DataDestroy = DataDestroy
UIPinUseSetView.ReInit = ReInit
UIPinUseSetView.OnBtnClick = OnBtnClick
UIPinUseSetView.RefreshState = RefreshState
return UIPinUseSetView
