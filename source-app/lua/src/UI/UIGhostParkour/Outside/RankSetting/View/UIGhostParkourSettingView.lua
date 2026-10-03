local UIGhostParkourSettingView = BaseClass("UIGhostParkourSettingView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIGhostParkourSettingView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
end

function UIGhostParkourSettingView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGhostParkourSettingView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnServer = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnServer:SetOnClick(function()
    self:OnBtnServerClick()
  end)
  self.textServerDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.imgServer = self.viewSkin:AddComponent(self, UIImage, 6)
  self.btnArea = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnArea:SetOnClick(function()
    self:OnBtnAreaClick()
  end)
  self.textAreaDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.imgArea = self.viewSkin:AddComponent(self, UIImage, 9)
  self.btnConfirm = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.textConfirm = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.btnCancel = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnCancel:SetOnClick(function()
    self:OnBtnCancelClick()
  end)
  self.textCancel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
end

function UIGhostParkourSettingView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.btnServer = nil
  self.textServerDesc = nil
  self.imgServer = nil
  self.btnArea = nil
  self.textAreaDesc = nil
  self.imgArea = nil
  self.btnConfirm = nil
  self.textConfirm = nil
  self.btnCancel = nil
  self.textCancel = nil
end

function UIGhostParkourSettingView:DataDefine()
  self.serverOpen = nil
  self.crossServerOpen = nil
  self.initCrossServer = nil
  self.initServer = nil
end

function UIGhostParkourSettingView:DataDestroy()
end

function UIGhostParkourSettingView:OnAddListener()
  base.OnAddListener(self)
end

function UIGhostParkourSettingView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIGhostParkourSettingView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIGhostParkourSettingView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIGhostParkourSettingView:OnBtnServerClick()
  if self.serverOpen == "1" then
    self.serverOpen = "0"
    UIUtil.ShowTipsId("ghost_parkour_zone_setting_0")
  else
    self.serverOpen = "1"
    UIUtil.ShowTipsId("ghost_parkour_zone_setting_1")
  end
  self:UpdateServer()
end

function UIGhostParkourSettingView:OnBtnAreaClick()
  if self.crossServerOpen == "1" then
    self.crossServerOpen = "0"
    UIUtil.ShowTipsId("ghost_parkour_season_setting_0")
  else
    self.crossServerOpen = "1"
    UIUtil.ShowTipsId("ghost_parkour_season_setting_1")
  end
  self:UpdateCrossServer()
end

function UIGhostParkourSettingView:OnBtnConfirmClick()
  if self.initServer ~= self.serverOpen then
    SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.GHOST_PARKOUR_ALLOW_SAME_SERVER_WATCH, self.serverOpen)
  end
  if self.initCrossServer ~= self.crossServerOpen then
    SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.GHOST_PARKOUR_ALLOW_CROSS_SERVER_WATCH, self.crossServerOpen)
  end
  UIUtil.ShowTipsId("ghost_parkour_setting_finish")
  self.ctrl:CloseSelf()
end

function UIGhostParkourSettingView:OnBtnCancelClick()
  self.ctrl:CloseSelf()
end

function UIGhostParkourSettingView:InitData()
  self.serverOpen = LuaEntry.Player:GetUserSetting(UserSettingKey.GHOST_PARKOUR_ALLOW_SAME_SERVER_WATCH)
  self.crossServerOpen = LuaEntry.Player:GetUserSetting(UserSettingKey.GHOST_PARKOUR_ALLOW_CROSS_SERVER_WATCH)
  if not self.serverOpen then
    self.serverOpen = "1"
  end
  if not self.crossServerOpen then
    self.crossServerOpen = "1"
  end
  self.initServer = self.serverOpen
  self.initCrossServer = self.crossServerOpen
  self:UpdateServer()
  self:UpdateCrossServer()
end

function UIGhostParkourSettingView:UpdateServer()
  self.imgServer.gameObject:SetActive(self.serverOpen == "1")
end

function UIGhostParkourSettingView:UpdateCrossServer()
  self.imgArea.gameObject:SetActive(self.crossServerOpen == "1")
end

return UIGhostParkourSettingView
