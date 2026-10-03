local KingdomSetAppointRightMessage = BaseClass("KingdomSetAppointRightMessage", SFSBaseMessage)
local base = SFSBaseMessage

function KingdomSetAppointRightMessage:OnCreate(positionId, appointRight)
  base.OnCreate(self)
  self.sfsObj:PutBool("appointRight", appointRight)
  self.sfsObj:PutUtfString("positionId", positionId)
end

function KingdomSetAppointRightMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.GetKingdomPositions, LuaEntry.Player:GetSourceServerId())
end

return KingdomSetAppointRightMessage
