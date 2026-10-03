local MailReadStatusMessage = BaseClass("MailReadStatusMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uid, type)
  base.OnCreate(self, uid, type)
  if uid ~= nil and type ~= nil then
    self.sfsObj:PutUtfString("uid", uid)
    self.sfsObj:PutInt("type", type)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  Logger.Log(t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
end

MailReadStatusMessage.OnCreate = OnCreate
MailReadStatusMessage.HandleMessage = HandleMessage
return MailReadStatusMessage
