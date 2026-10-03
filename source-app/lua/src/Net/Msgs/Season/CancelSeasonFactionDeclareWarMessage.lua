local CancelSeasonFactionDeclareWarMessage = BaseClass("CancelSeasonFactionDeclareWarMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CancelSeasonFactionDeclareWarMessage:OnCreate(targetAllianceId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetAllianceId", targetAllianceId)
end

function CancelSeasonFactionDeclareWarMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    if errCode == "camp_battle_tip006" then
      SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionDeclareWarDetail, DataCenter.SeasonFactionWarDataManager.defenceCampId)
    end
    return
  end
  DataCenter.SeasonFactionWarDataManager.targetAllianceId = t.targetAllianceId
  EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionDoWarDeclare, t)
end

return CancelSeasonFactionDeclareWarMessage
