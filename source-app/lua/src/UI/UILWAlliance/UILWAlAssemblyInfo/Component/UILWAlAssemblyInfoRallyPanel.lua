local base = UIBaseContainer
local UILWAlAssemblyInfoRallyPanel = BaseClass("UILWAlAssemblyInfoRallyPanel", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWAlAssemblyInfoRallyPanel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlAssemblyInfoRallyPanel:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlAssemblyInfoRallyPanel:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.toggleShowRally = self.viewSkin:AddComponent(self, UIToggle, 1)
  self.textShowRallyToggle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compRallyBubbleBg = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.textRallyBubble = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.toggleShowRally:SetOnValueChanged(function(isOn)
    local hide = LuaEntry.Player:GetUserSetting(UserSettingKey.ALLIANCE_RALLY_HIDE_TEXT) == "1"
    if isOn and hide then
      SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.ALLIANCE_RALLY_HIDE_TEXT, "0")
    elseif not isOn and not hide then
      SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.ALLIANCE_RALLY_HIDE_TEXT, "1")
    end
  end)
  self.textRallyBubble:SetLocalText("alliance_AssemblyPoint_title_01")
  self.textShowRallyToggle:SetLocalText("alliance_AssemblyPoint_opt_01")
end

function UILWAlAssemblyInfoRallyPanel:ComponentDestroy()
  self.viewSkin = nil
  self.toggleShowRally = nil
  self.textShowRallyToggle = nil
  self.compRallyBubbleBg = nil
  self.textRallyBubble = nil
end

function UILWAlAssemblyInfoRallyPanel:DataDefine()
  self:Refresh()
end

function UILWAlAssemblyInfoRallyPanel:DataDestroy()
end

function UILWAlAssemblyInfoRallyPanel:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateSelfAllianceRallyPointBubble, self.Refresh)
end

function UILWAlAssemblyInfoRallyPanel:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateSelfAllianceRallyPointBubble, self.Refresh)
  base.OnRemoveListener(self)
end

function UILWAlAssemblyInfoRallyPanel:Refresh()
  local hide = LuaEntry.Player:GetUserSetting(UserSettingKey.ALLIANCE_RALLY_HIDE_TEXT) == "1"
  self.toggleShowRally:SetIsOnWithoutNotify(not hide)
  self.compRallyBubbleBg:SetActive(false)
end

return UILWAlAssemblyInfoRallyPanel
