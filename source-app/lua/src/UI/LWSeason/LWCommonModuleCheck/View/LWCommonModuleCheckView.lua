local base = UIBaseView
local LWCommonModuleCheckView = BaseClass("LWCommonModuleCheckView", base)
local UIGray = CS.UIGray
local btnClose_path = "PopUpTitle/CloseBtn"
local btnPanel_path = "panel"
local text_path = "PopUpTitle/ScrollView/Viewport/Text"
local btnOk_path = "PopUpTitle/Btn"
local textTime_path = "PopUpTitle/Btn/TimeText"
local btn_text_path = "PopUpTitle/Btn/BtnText"
local setting_toggle_path = "PopUpTitle/SettingToggle"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.setting_toggle = self:AddComponent(UIToggle, setting_toggle_path)
  self.btnClose = self:AddComponent(UIButton, btnClose_path)
  self.btnPanel = self:AddComponent(UIButton, btnPanel_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.btnOk = self:AddComponent(UIButton, btnOk_path)
  self.textTime = self:AddComponent(UITextMeshProUGUIEx, textTime_path)
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, btn_text_path)
  self.btnClose:SetOnClick(BindCallback(self, self.ClickClose))
  self.btnPanel:SetOnClick(BindCallback(self, self.ClickClose))
  self.btnOk:SetOnClick(BindCallback(self, self.OnClickOkBtn))
  self.text:OnPointerClick(function(eventData)
    UIUtil.UseJumpLink(self.text, eventData)
  end)
  self.setting_toggle:SetIsOn(false)
  UIGray.SetGray(self.btnOk.transform, false, true)
  self.setting_toggle:SetOnValueChanged(function(tf)
    self:RefreshBtnState()
  end)
end

local function ComponentDestroy(self)
  self.setting_toggle = nil
  self.btnClose = nil
  self.btnPanel = nil
  self.text = nil
  self.btnOk = nil
  self.textTime = nil
  self.btn_text = nil
end

function LWCommonModuleCheckView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UserSettingChanged, self.UserSettingChangedHandle)
end

function LWCommonModuleCheckView:OnRemoveListener()
  self:RemoveUIListener(EventId.UserSettingChanged, self.UserSettingChangedHandle)
  base.OnRemoveListener(self)
end

function LWCommonModuleCheckView:RefreshView()
  local key, txt1, txt2, callback, clickTime = self:GetUserData()
  self.closeCallBack = callback
  self.key = key
  self.clickTime = clickTime or 5
  self.text:SetLocalText(txt1)
  self.btn_text:SetLocalText(txt2)
  self:RefreshBtnState()
end

function LWCommonModuleCheckView:OnClickOkBtn()
  if self.clickTime then
    UIUtil.ShowTipsId("season_alliance_photo_tips_15")
    return
  end
  if self.setting_toggle:GetIsOn() ~= true then
    UIUtil.ShowTipsId("season_alliance_photo_tips_15")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.UserSetting, self.key, "1")
end

function LWCommonModuleCheckView:Update1000MS()
  if self.clickTime then
    self.clickTime = self.clickTime - 1
    if self.clickTime <= 0 then
      self.clickTime = nil
    end
    self:RefreshBtnState()
  end
end

function LWCommonModuleCheckView:RefreshBtnState()
  if self.clickTime then
    CS.UIGray.SetGray(self.btnOk.transform, true, true)
    self.textTime:SetText(string.format("%ss", self.clickTime))
    self.textTime:SetActive(true)
    return
  end
  self.textTime:SetActive(false)
  CS.UIGray.SetGray(self.btnOk.transform, not self.setting_toggle:GetIsOn(), true)
end

function LWCommonModuleCheckView:UserSettingChangedHandle(type)
  if type == self.key then
    self.ctrl:CloseSelf()
  end
end

function LWCommonModuleCheckView:ClickClose()
  self.ctrl:CloseSelf()
  if self.closeCallBack then
    self.closeCallBack()
  end
end

LWCommonModuleCheckView.OnCreate = OnCreate
LWCommonModuleCheckView.OnDestroy = OnDestroy
LWCommonModuleCheckView.ComponentDefine = ComponentDefine
LWCommonModuleCheckView.ComponentDestroy = ComponentDestroy
return LWCommonModuleCheckView
