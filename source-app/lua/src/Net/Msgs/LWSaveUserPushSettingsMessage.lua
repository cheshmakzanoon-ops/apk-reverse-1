local LWSaveUserPushSettingsMessage = BaseClass("LWSaveUserPushSettingsMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, idList, stateList)
  base.OnCreate(self)
  self.sfsObj:PutIntArray("idList", idList)
  self.sfsObj:PutIntArray("stateList", stateList)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

LWSaveUserPushSettingsMessage.OnCreate = OnCreate
LWSaveUserPushSettingsMessage.HandleMessage = HandleMessage
return LWSaveUserPushSettingsMessage
