local UIShakeTipView = BaseClass("UIShakeTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnPanel = self:AddComponent(UIButton, "Root/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textDes1 = self:AddComponent(UITextMeshProUGUIEx, "Root/Common_bg_orange/TopContent/Text")
  self.textPushName = self:AddComponent(UITextMeshProUGUIEx, "Root/Common_bg_orange/MidContent/PushName")
  self.textPushDes = self:AddComponent(UITextMeshProUGUIEx, "Root/Common_bg_orange/MidContent/PushDes")
  self.slider = self:AddComponent(UISlider, "Root/Common_bg_orange/MidContent/Slider")
  self.btnSwitch = self:AddComponent(UIButton, "Root/Common_bg_orange/MidContent/SwitchBtn")
  self.btnSwitch:SetOnClick(function()
    self:OnBtnSwitchClick()
  end)
  self.btnCancel = self:AddComponent(UIButton, "Root/Common_bg_orange/BottomContent/Layout/BtnCancel")
  self.btnCancel:SetOnClick(function()
    self:OnBtnCancelClick()
  end)
  self.btnConfirm = self:AddComponent(UIButton, "Root/Common_bg_orange/BottomContent/Layout/BtnConfirm")
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.textBtnCancel = self:AddComponent(UITextMeshProUGUIEx, "Root/Common_bg_orange/BottomContent/Layout/BtnCancel/BtnCancelText")
  self.textBtnConfirm = self:AddComponent(UITextMeshProUGUIEx, "Root/Common_bg_orange/BottomContent/Layout/BtnConfirm/BtnConfirmText")
  self.btnClose = self:AddComponent(UIButton, "Root/Common_bg_orange/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/Common_bg_orange/Common_img_title/titleText")
  self.textDes1:SetLocalText("pc_shake_tips_02")
  self.textPushName:SetLocalText("setting_shakeCollect_title")
  self.textPushDes:SetLocalText("pc_shake_tips_01")
  self.textBtnCancel:SetLocalText(110106)
  self.textBtnConfirm:SetLocalText(110006)
  self.textTitle:SetLocalText(100378)
end

local function ComponentDestroy(self)
  self.btnPanel = nil
  self.textDes1 = nil
  self.textPushName = nil
  self.textPushDes = nil
  self.slider = nil
  self.btnSwitch = nil
  self.btnCancel = nil
  self.btnConfirm = nil
  self.textBtnCancel = nil
  self.textBtnConfirm = nil
  self.btnClose = nil
  self.textTitle = nil
end

local function DataDefine(self)
  self.isOn = CS.GameEntry.Setting:GetBool(SettingKeys.SHAKE_COLLECT_RES, true)
  self.slider:SetValue(self.isOn and 1 or 0)
end

local function DataDestroy(self)
  self.isOn = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnPanelClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnSwitchClick(self)
  self.isOn = not self.isOn
  self.slider:SetValue(self.isOn and 1 or 0)
  CS.GameEntry.Setting:SetBool(SettingKeys.SHAKE_COLLECT_RES, self.isOn)
  EventManager:GetInstance():Broadcast(EventId.RefreshShakeCollectResSetting, self.isOn)
end

local function OnBtnCancelClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnConfirmClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

UIShakeTipView.OnCreate = OnCreate
UIShakeTipView.OnDestroy = OnDestroy
UIShakeTipView.OnEnable = OnEnable
UIShakeTipView.OnDisable = OnDisable
UIShakeTipView.ComponentDefine = ComponentDefine
UIShakeTipView.ComponentDestroy = ComponentDestroy
UIShakeTipView.DataDefine = DataDefine
UIShakeTipView.DataDestroy = DataDestroy
UIShakeTipView.OnAddListener = OnAddListener
UIShakeTipView.OnRemoveListener = OnRemoveListener
UIShakeTipView.OnBtnPanelClick = OnBtnPanelClick
UIShakeTipView.OnBtnSwitchClick = OnBtnSwitchClick
UIShakeTipView.OnBtnCancelClick = OnBtnCancelClick
UIShakeTipView.OnBtnConfirmClick = OnBtnConfirmClick
UIShakeTipView.OnBtnCloseClick = OnBtnCloseClick
return UIShakeTipView
