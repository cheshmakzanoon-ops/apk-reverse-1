local UIPlayerDownloadCenterSettingView = BaseClass("UIPlayerDownloadCenterSettingView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIPlayerDownloadCenterSettingView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIPlayerDownloadCenterSettingView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPlayerDownloadCenterSettingView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textAutoDownloadDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textAutoClearDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnConfirm = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.btnAutoDownloadSwitch = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnAutoDownloadSwitch:SetOnClick(function()
    self:OnBtnAutoDownloadSwitchClick()
  end)
  self.compAutoDownloadIconOn = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.compAutoClearIconOn = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.btnAutoClearSwitch = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnAutoClearSwitch:SetOnClick(function()
    self:OnBtnAutoClearSwitchClick()
  end)
  self.textBtnConfirmName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnPanel:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
end

function UIPlayerDownloadCenterSettingView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textAutoDownloadDesc = nil
  self.textAutoClearDesc = nil
  self.btnConfirm = nil
  self.btnAutoDownloadSwitch = nil
  self.compAutoDownloadIconOn = nil
  self.compAutoClearIconOn = nil
  self.btnAutoClearSwitch = nil
  self.textBtnConfirmName = nil
  self.btnPanel = nil
end

function UIPlayerDownloadCenterSettingView:DataDefine()
end

function UIPlayerDownloadCenterSettingView:DataDestroy()
end

function UIPlayerDownloadCenterSettingView:OnAddListener()
  base.OnAddListener(self)
end

function UIPlayerDownloadCenterSettingView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIPlayerDownloadCenterSettingView:RefreshView()
  self.textTitle:SetLocalText("download_center_set_title")
  self.textAutoDownloadDesc:SetLocalText("download_center_set_auto_load")
  self.textAutoClearDesc:SetLocalText("download_center_set_auto_del")
  self.textBtnConfirmName:SetLocalText("download_center_set_confirm_btn")
  local isAutoDownloadEnabled = DataCenter.PlayerDownloadCenterManager:GetAutoDownloadSettingState()
  self:RefreshToggleState(isAutoDownloadEnabled, self.compAutoDownloadIconOn)
  local isAutoClearEnabled = DataCenter.PlayerDownloadCenterManager:GetAutoClearSettingState()
  self:RefreshToggleState(isAutoClearEnabled, self.compAutoClearIconOn)
end

function UIPlayerDownloadCenterSettingView:RefreshToggleState(state, onIcon)
  local compIconBtnOnPosX = 0
  if state then
    compIconBtnOnPosX = 36
  end
  onIcon:SetAnchoredPositionXY(compIconBtnOnPosX, onIcon:GetAnchoredPositionY())
end

function UIPlayerDownloadCenterSettingView:OnBtnCloseClick()
  self.ctrl.CloseSelf()
end

function UIPlayerDownloadCenterSettingView:OnBtnConfirmClick()
  self.ctrl.CloseSelf()
end

function UIPlayerDownloadCenterSettingView:OnBtnAutoDownloadSwitchClick()
  local isAutoDownloadEnabled = DataCenter.PlayerDownloadCenterManager:GetAutoDownloadSettingState()
  DataCenter.PlayerDownloadCenterManager:SetAutoDownloadSettingState(not isAutoDownloadEnabled)
  self:RefreshToggleState(not isAutoDownloadEnabled, self.compAutoDownloadIconOn)
  EventManager:GetInstance():Broadcast(EventId.ChangeAutoDownloadSettingState)
end

function UIPlayerDownloadCenterSettingView:OnBtnAutoClearSwitchClick()
  local isAutoClearEnabled = DataCenter.PlayerDownloadCenterManager:GetAutoClearSettingState()
  DataCenter.PlayerDownloadCenterManager:SetAutoClearSettingState(not isAutoClearEnabled)
  self:RefreshToggleState(not isAutoClearEnabled, self.compAutoClearIconOn)
end

return UIPlayerDownloadCenterSettingView
