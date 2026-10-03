local SeasonFactionWarInviteFeedbackMessage = BaseClass("SeasonFactionWarInviteFeedbackMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonFactionWarInviteFeedbackMessage:OnCreate(senderAllianceId, chooseType)
  base.OnCreate(self)
  self.sfsObj:PutInt("chooseType", chooseType)
  self.sfsObj:PutUtfString("senderAllianceId", senderAllianceId)
end

function SeasonFactionWarInviteFeedbackMessage:HandleMessage(t)
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
  EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionWarInviteFeedbackUpdate, t)
end

return SeasonFactionWarInviteFeedbackMessage
