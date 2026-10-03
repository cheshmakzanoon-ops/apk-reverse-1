local base = UIBaseView
local ModuleCheck = BaseClass("ModuleCheck", base)
local UIGray = CS.UIGray
local btnClose_path = "PopUpTitle/CloseBtn"
local btnPanel_path = "panel"
local text_path = "PopUpTitle/ScrollView/Viewport/Text"
local btnOk_path = "PopUpTitle/Btn"
local textTime_path = "PopUpTitle/Btn/TimeText"
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
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
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
end

function ModuleCheck:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonPhotoModuleOpen, self.OnModuleOpen)
end

function ModuleCheck:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonPhotoModuleOpen, self.OnModuleOpen)
  base.OnRemoveListener(self)
end

function ModuleCheck:RefreshView()
  self.clickTime = 5
  self:RefreshBtnState()
end

function ModuleCheck:OnClickOkBtn()
  if self.clickTime then
    UIUtil.ShowTipsId("season_alliance_photo_tips_15")
    return
  end
  if self.setting_toggle:GetIsOn() ~= true then
    UIUtil.ShowTipsId("season_alliance_photo_tips_15")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonPhotoModuleOpen)
end

function ModuleCheck:OnModuleOpen(status)
  if status == 1 then
    self.ctrl:CloseSelf()
  end
end

function ModuleCheck:Update1000MS()
  if self.clickTime then
    self.clickTime = self.clickTime - 1
    if self.clickTime <= 0 then
      self.clickTime = nil
    end
    self:RefreshBtnState()
  end
end

function ModuleCheck:RefreshBtnState()
  if self.clickTime then
    CS.UIGray.SetGray(self.btnOk.transform, true, true)
    self.textTime:SetText(string.format("%ss", self.clickTime))
    self.textTime:SetActive(true)
    return
  end
  self.textTime:SetActive(false)
  CS.UIGray.SetGray(self.btnOk.transform, not self.setting_toggle:GetIsOn(), true)
end

ModuleCheck.OnCreate = OnCreate
ModuleCheck.OnDestroy = OnDestroy
ModuleCheck.ComponentDefine = ComponentDefine
ModuleCheck.ComponentDestroy = ComponentDestroy
return ModuleCheck
