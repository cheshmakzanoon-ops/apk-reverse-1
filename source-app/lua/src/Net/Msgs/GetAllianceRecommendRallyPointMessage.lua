local GetAllianceRecommendRallyPointMessage = BaseClass("GetAllianceRecommendRallyPointMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetAllianceRecommendRallyPointMessage:OnCreate(param)
  base.OnCreate(self)
end

function GetAllianceRecommendRallyPointMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceRallyPointDataManager:HandleSetRecommendRallyPoint(t)
  end
end

return GetAllianceRecommendRallyPointMessage
