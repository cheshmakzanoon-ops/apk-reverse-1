local MailGetMessage = BaseClass("MailGetMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, mailId, mailType, senderUid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uid", mailId)
  self.sfsObj:PutUtfString("type", mailType)
  self.sfsObj:PutUtfString("toUser", senderUid)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.MailDataManager:HandleMailGetMessage(message)
end

MailGetMessage.OnCreate = OnCreate
MailGetMessage.HandleMessage = HandleMessage
return MailGetMessage
