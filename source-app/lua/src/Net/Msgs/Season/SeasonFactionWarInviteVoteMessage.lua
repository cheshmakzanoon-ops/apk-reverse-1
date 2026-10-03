local SeasonFactionWarInviteVoteMessage = BaseClass("SeasonFactionWarInviteVoteMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonFactionWarInviteVoteMessage:OnCreate(targetAllianceId, chooseType)
  base.OnCreate(self)
  self.sfsObj:PutInt("chooseType", chooseType)
  self.sfsObj:PutUtfString("targetAllianceId", targetAllianceId)
end

function SeasonFactionWarInviteVoteMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode == "camp_battle_tip009" then
      SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionWarVsInfo)
    else
      UIUtil.ShowTipsId(errCode)
    end
    return
  end
  EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionWarInviteVoteUpdate, t)
end

return SeasonFactionWarInviteVoteMessage
