local PushReceiveAssignRedPacketMessage = BaseClass("PushReceiveAssignRedPacketMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushReceiveAssignRedPacketMessage:OnCreate()
  base.OnCreate(self)
end

function PushReceiveAssignRedPacketMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonTradeShopDataManager:HandleOneRedPacket(t, true)
  end
end

return PushReceiveAssignRedPacketMessage
