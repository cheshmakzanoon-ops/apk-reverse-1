local UIRoleLoginView = BaseClass("UIRoleLoginView", UIBaseView)
local base = UIBaseView
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization
local txt_title_path = "UIAccountPopUpTitle/titleText"
local close_btn_path = "UIAccountPopUpTitle/CloseBtn"
local return_btn_path = "UIAccountPopUpTitle/panel"
local rolesLoginTips_txt_path = "Txt_RolesLoginTips"
local name_txt_path = "Txt_Name"
local head_path = "UIPlayerHead/HeadIcon"
local player_head_path = "PlayerBtn/UIPlayerHead/HeadIcon"
local headFg_path = "PlayerBtn/UIPlayerHead/Foreground"
local lv_txt_path = "PlayerBtn/LevelBg/LevelText"
local left_btn_path = "BtnGo/LeftBtn"
local left_txt_path = "BtnGo/LeftBtn/LeftBtnName"
local right_btn_path = "BtnGo/RightBtn"
local right_txt_path = "BtnGo/RightBtn/RightBtnName"

function UIRoleLoginView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIRoleLoginView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIRoleLoginView:ComponentDefine()
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.player_head = self:AddComponent(UIPlayerHead, player_head_path)
  self.playerHeadFg = self:AddComponent(UIImage, headFg_path)
  self.player_level = self:AddComponent(UIText, lv_txt_path)
  self._rolesLoginTips_txt = self:AddComponent(UIText, rolesLoginTips_txt_path)
  self._name_txt = self:AddComponent(UIText, name_txt_path)
  self._left_btn = self:AddComponent(UIButton, left_btn_path)
  self._right_btn = self:AddComponent(UIButton, right_btn_path)
  self._left_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self._right_btn:SetOnClick(function()
    self:OnClickLogin()
  end)
  self._left_txt = self:AddComponent(UIText, left_txt_path)
  self._right_txt = self:AddComponent(UIText, right_txt_path)
end

function UIRoleLoginView:ComponentDestroy()
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self._rolesLoginTips_txt = nil
  self._name_txt = nil
  self.headIconN = nil
  self._left_btn = nil
  self._right_btn = nil
  self._left_txt = nil
  self._right_txt = nil
end

function UIRoleLoginView:DataDefine()
end

function UIRoleLoginView:DataDestroy()
end

function UIRoleLoginView:OnEnable()
  base.OnEnable(self)
end

function UIRoleLoginView:OnDisable()
  base.OnDisable(self)
end

function UIRoleLoginView:ReInit()
  local param = self:GetUserData()
  self.param = param
  self._left_txt:SetLocalText(100289)
  self._right_txt:SetLocalText(100288)
  local uid = param.gameUid
  local pic = param.pic
  local picVer = param.picVer
  self.player_head:SetData(uid, pic, picVer)
  local playerLevel = param.gameUserLevel
  if string.IsNullOrEmpty(playerLevel) then
    self.player_level:SetText("")
  else
    self.player_level:SetText(playerLevel)
  end
  self.txt_title:SetLocalText(208228)
  self._rolesLoginTips_txt:SetLocalText(208229)
  if param.alAbbr ~= nil and param.alAbbr ~= "" then
    self._name_txt:SetText("[" .. param.alAbbr .. "]" .. param.gameUserName)
  else
    self._name_txt:SetText(param.gameUserName)
  end
end

function UIRoleLoginView:OnClickLogin()
  Logger.LogInfo("[AT]SetGUID_UIRoleLogn:" .. tostring(self.param.gameUid))
  CS.AccountCredentialManager.ClearAll()
  CS.AccountCredentialManager.SetServerNetInfo(self.param.ip, self.param.port, self.param.zone, 0)
  CS.AccountCredentialManager.SetLoginKey(self.param.loginKey)
  CS.AccountCredentialManager.SetUID(self.param.gameUid)
  CS.AccountCredentialManager.Save()
  CS.AIHelp.AIHelpProxy.Logout()
  EventManager:GetInstance():Broadcast(EventId.SwitchAccount, self.param.gameUid)
  SFSNetwork.SendMessage(MsgDefines.UserCleanPost)
end

return UIRoleLoginView
