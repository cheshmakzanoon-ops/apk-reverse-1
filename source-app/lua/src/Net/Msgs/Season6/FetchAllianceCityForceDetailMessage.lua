local FetchAllianceCityForceDetailMessage = BaseClass("FetchAllianceCityForceDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchAllianceCityForceDetailMessage:OnCreate(allianceId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetAllianceId", allianceId)
end

function FetchAllianceCityForceDetailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.WorldAllianceCityDataManager:SetAllianceCityForceDetail(t.targetAllianceId, t)
  DataCenter.SeasonCampDestroyManager:OnGetInfluenceDetailCallback(t)
end

return FetchAllianceCityForceDetailMessage
