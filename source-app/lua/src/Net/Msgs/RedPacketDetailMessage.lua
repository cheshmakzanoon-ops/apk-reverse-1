local RedPacketDetailMessage = BaseClass("RedPacketDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid, redPacketId, ChatType, serverId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uuid", uuid)
  self.sfsObj:PutInt("cfgId", redPacketId)
  self.sfsObj:PutInt("chatType", ChatType)
  self.sfsObj:PutInt("serverId", serverId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    local lang = Localization:GetString(t.errorCode)
    local str = lang or t.errorCode
    UIUtil.ShowTips(lang or str)
  else
    EventManager:GetInstance():Broadcast(EventId.RedPacketDetails, t)
  end
end

RedPacketDetailMessage.OnCreate = OnCreate
RedPacketDetailMessage.HandleMessage = HandleMessage
return RedPacketDetailMessage
