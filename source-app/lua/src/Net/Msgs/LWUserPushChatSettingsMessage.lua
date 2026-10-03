local lwUserPushChatSettingsMessage = BaseClass("lwUserPushChatSettingsMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uid, state)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uid", tostring(uid))
  self.sfsObj:PutInt("state", tonumber(state))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.PushSettingsManager:InitPushSettingUserList(t)
  end
end

lwUserPushChatSettingsMessage.OnCreate = OnCreate
lwUserPushChatSettingsMessage.HandleMessage = HandleMessage
return lwUserPushChatSettingsMessage
