local PushAllianceLuckSiphonInfoMessage = BaseClass("PushAllianceLuckSiphonInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceLuckSiphonInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceLuckSiphonInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LuckyBuffManager:AddLuckyPacket(t)
    EventManager:GetInstance():Broadcast(EventId.LUCKY_PACKET_GAIN)
  end
end

return PushAllianceLuckSiphonInfoMessage
