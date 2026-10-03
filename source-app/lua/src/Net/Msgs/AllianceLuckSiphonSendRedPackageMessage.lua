local AllianceLuckSiphonSendRedPackageMessage = BaseClass("AllianceLuckSiphonSendRedPackageMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceLuckSiphonSendRedPackageMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", param.uuid)
end

function AllianceLuckSiphonSendRedPackageMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LuckyBuffManager:UpdateLuckyPacket(t.uuid, t.count)
    EventManager:GetInstance():Broadcast(EventId.LUCKY_PACKET_SHARE_SUCCESS)
    if t.itemEffectObj and t.itemEffectObj.redPackets then
      DataCenter.RedPacketManager:UpdateRedPacket(t.itemEffectObj)
    end
  end
end

return AllianceLuckSiphonSendRedPackageMessage
