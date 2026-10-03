local MailSendMessage = BaseClass("MailSendMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, name, title, contents, allianceId, targetUid, sendLocalTime, type, serverId)
  base.OnCreate(self)
  if name then
    self.sfsObj:PutUtfString("name", name)
  end
  if title then
    self.sfsObj:PutUtfString("title", title)
  end
  if contents then
    self.sfsObj:PutUtfString("contents", contents)
  end
  if allianceId then
    self.sfsObj:PutUtfString("allianceId", allianceId)
  end
  if targetUid then
    self.sfsObj:PutUtfString("targetUid", targetUid)
  end
  if sendLocalTime then
    self.sfsObj:PutLong("sendLocalTime", sendLocalTime)
  end
  self.sfsObj:PutInt("type", type)
  if serverId then
    self.sfsObj:PutInt("serverId", serverId)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowErrorCodeTips(t)
  end
  EventManager:GetInstance():Broadcast(EventId.MailPush)
  if t.gold then
    LuaEntry.Player.gold = t.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
end

MailSendMessage.OnCreate = OnCreate
MailSendMessage.HandleMessage = HandleMessage
return MailSendMessage
