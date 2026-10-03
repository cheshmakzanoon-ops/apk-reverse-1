local PushKingdomPositionChangeMessage = BaseClass("PushKingdomPositionChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushKingdomPositionChangeMessage:OnCreate()
  base.OnCreate(self)
end

function PushKingdomPositionChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local serverId = LuaEntry.Player:GetSourceServerId()
  if toInt(serverId) > 0 then
    SFSNetwork.SendMessage(MsgDefines.GetKingdomPositions, serverId)
    SFSNetwork.SendMessage(MsgDefines.GetKingInfo, serverId)
  end
end

return PushKingdomPositionChangeMessage
