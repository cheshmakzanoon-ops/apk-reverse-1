local UIChatSearchUserItem = BaseClass("UIChatSearchUserItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local _cp_username = "username"
local _cp_toggle = "toggleBtn"

function UIChatSearchUserItem:ComponentDefine()
  self._txtusername = self:AddComponent(UIText, _cp_username)
  self._toggleBtn = self:AddComponent(UIToggle, _cp_toggle)
end

function UIChatSearchUserItem:DataInit()
  self._freeUserItemList = {}
  self._userItemList = {}
  self._loadingPrefab = {}
  self._prefabNameIndex = 0
end

function UIChatSearchUserItem:OnCreate()
  base.OnCreate(self)
  self:DataInit()
  self:ComponentDefine()
end

function UIChatSearchUserItem:OnEnable()
  base.OnEnable(self)
  self._toggleBtn:SetIsOn(false)
end

function UIChatSearchUserItem:OnAddListener()
  self:AddUIListener(EventId.UPDATE_MSG_USERINFO, self.OnRefresh)
end

function UIChatSearchUserItem:OnRemoveListener()
  self:RemoveUIListener(EventId.UPDATE_MSG_USERINFO, self.OnRefresh)
end

function UIChatSearchUserItem:OnRefresh()
  local userinfo = ChatInterface.getUserData(self._userInfo.uid, true)
  self:SetData(userinfo)
end

function UIChatSearchUserItem:OnDisable()
  base.OnDisable(self)
end

function UIChatSearchUserItem:SetData(userInfo)
  self._userInfo = userInfo
  local username = ""
  if userInfo.name ~= nil then
    username = userInfo.name
  else
    username = userInfo:GetUserName()
  end
  self._txtusername:SetText(username)
  self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
end

function UIChatSearchUserItem:GetToggle()
  return self._toggleBtn:GetIsOn()
end

function UIChatSearchUserItem:GetUserData()
  return self._userInfo
end

function UIChatSearchUserItem:SetInChatRoom(value)
  self._toggleBtn:SetIsOn(value)
  self._toggleBtn:SetEnabled(not value)
end

return UIChatSearchUserItem
