local PushAllianceRecommendRallyWorldMarkMessage = BaseClass("PushAllianceRecommendRallyWorldMarkMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceRecommendRallyWorldMarkMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceRecommendRallyWorldMarkMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceRallyPointDataManager:HandleSetRecommendRallyPoint(t)
  end
end

return PushAllianceRecommendRallyWorldMarkMessage
