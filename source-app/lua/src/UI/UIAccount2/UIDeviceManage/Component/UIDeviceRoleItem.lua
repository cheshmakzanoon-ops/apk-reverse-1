local UIDeviceRoleItem = BaseClass("UIDeviceRoleItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIDeviceRoleItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIDeviceRoleItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDeviceRoleItem:OnEnable()
  base.OnEnable(self)
end

function UIDeviceRoleItem:OnDisable()
  base.OnDisable(self)
end

function UIDeviceRoleItem:ComponentDefine()
  self._server_txt = self:AddComponent(UIText, "Rect_Normal/Content/Txt_Server")
  self._name_txt = self:AddComponent(UIText, "Rect_Normal/Txt_Name")
  self._power_txt = self:AddComponent(UIText, "Rect_Normal/Content/Txt_Power")
  self._curAccount_img = self:AddComponent(UIImage, "Rect_Normal/Img_CurAccount")
  self.player_head = self:AddComponent(UIPlayerHead, "Rect_Normal/PlayerBtn/UIPlayerHead/HeadIcon")
  self.playerHeadFg = self:AddComponent(UIImage, "Rect_Normal/PlayerBtn/UIPlayerHead/frameBg")
  self.player_level = self:AddComponent(UIText, "Rect_Normal/PlayerBtn/LevelBg/LevelText")
end

function UIDeviceRoleItem:ComponentDestroy()
  self._server_txt = nil
  self._name_txt = nil
  self._power_txt = nil
  self._curAccount_img = nil
  self.player_head = nil
  self.playerHeadFg = nil
  self.player_level = nil
end

function UIDeviceRoleItem:SetData(param, deviceId)
  if param.alAbbr ~= nil and param.alAbbr ~= "" then
    self._name_txt:SetText("[" .. param.alAbbr .. "]" .. param.gameUserName)
  else
    self._name_txt:SetText(param.gameUserName)
  end
  self._server_txt:SetLocalText(208236, param.id)
  self._power_txt:SetLocalText(100392, string.GetFormattedSeperatorNum(param.power))
  local uid = param.gameUid
  local pic = param.pic
  local picVer = param.picVer
  self.player_head:SetData(uid, pic, picVer)
  if not string.IsNullOrEmpty(param.gameUserLevel) then
    self.player_level:SetText(param.gameUserLevel)
  else
    self.player_level:SetText("")
  end
  local myDeviceId = CS.GameEntry.Setting:GetString(SettingKeys.DEVICE_ID, "")
  self._curAccount_img:SetActive(param.gameUid == LuaEntry.Player.uid and myDeviceId == deviceId)
end

return UIDeviceRoleItem
