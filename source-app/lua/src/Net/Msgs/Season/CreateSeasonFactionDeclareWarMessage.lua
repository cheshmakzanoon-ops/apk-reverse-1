local CreateSeasonFactionDeclareWarMessage = BaseClass("CreateSeasonFactionDeclareWarMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CreateSeasonFactionDeclareWarMessage:OnCreate(targetAllianceId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetAllianceId", targetAllianceId)
end

function CreateSeasonFactionDeclareWarMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionDeclareWarDetail, DataCenter.SeasonFactionWarDataManager.defenceCampId)
    return
  end
  DataCenter.SeasonFactionWarDataManager.targetAllianceId = t.targetAllianceId
  EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionDoWarDeclare, t)
end

return CreateSeasonFactionDeclareWarMessage
