local AllianceLuckSiphonGainInfoMessage = BaseClass("AllianceLuckSiphonGainInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceLuckSiphonGainInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function AllianceLuckSiphonGainInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LuckyBuffManager:OnReceiveLuckyPacketData(t)
    EventManager:GetInstance():Broadcast(EventId.LUCKY_PACKET_GAIN)
  end
end

return AllianceLuckSiphonGainInfoMessage
