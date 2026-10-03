local SeasonFactionWarInviteSendMessage = BaseClass("SeasonFactionWarInviteSendMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonFactionWarInviteSendMessage:OnCreate(targetAllianceId, message)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("message", message or "")
  self.sfsObj:PutUtfString("targetAllianceId", targetAllianceId)
end

function SeasonFactionWarInviteSendMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionWarInviteList)
    return
  end
  if t.allianceId and t.overTime and t.state == 0 then
    UIUtil.ShowTipsId("season_s2_faction_war_88")
    EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionWarInviteSendUpdate, t)
  end
end

return SeasonFactionWarInviteSendMessage
