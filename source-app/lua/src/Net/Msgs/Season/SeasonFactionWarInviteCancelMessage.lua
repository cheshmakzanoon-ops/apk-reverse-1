local SeasonFactionWarInviteCancelMessage = BaseClass("SeasonFactionWarInviteCancelMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonFactionWarInviteCancelMessage:OnCreate(targetAllianceId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetAllianceId", targetAllianceId)
end

function SeasonFactionWarInviteCancelMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionWarVsInfo)
    return
  end
  if t.targetAllianceId then
    EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionWarInviteCancelUpdate, t.targetAllianceId)
  end
end

return SeasonFactionWarInviteCancelMessage
