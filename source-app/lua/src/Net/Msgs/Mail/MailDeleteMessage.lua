local MailDeleteMessage = BaseClass("MailDeleteMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uids, num)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uids", uids)
  self.sfsObj:PutInt("num", num)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  Logger.Log(t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId(310112)
  end
end

MailDeleteMessage.OnCreate = OnCreate
MailDeleteMessage.HandleMessage = HandleMessage
return MailDeleteMessage
