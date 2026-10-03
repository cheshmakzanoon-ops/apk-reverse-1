local BiuBiuPVPShareMessage = BaseClass("BiuBiuPVPShareMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, channel, touid)
  base.OnCreate(self)
  self.sfsObj:PutInt("channel", channel)
  if touid then
    self.sfsObj:PutUtfString("touid", touid)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId(120061)
    EventManager:GetInstance():Broadcast(EventId.SeasonBiuBiuChatShared)
  end
end

BiuBiuPVPShareMessage.OnCreate = OnCreate
BiuBiuPVPShareMessage.HandleMessage = HandleMessage
return BiuBiuPVPShareMessage
