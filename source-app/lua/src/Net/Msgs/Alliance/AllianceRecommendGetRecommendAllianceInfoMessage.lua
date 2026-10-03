local AllianceRecommendGetRecommendAllianceInfoMessage = BaseClass("AllianceRecommendGetRecommendAllianceInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceRecommendGetRecommendAllianceInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function AllianceRecommendGetRecommendAllianceInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.AllianceRecommendGetRecommendAllianceInfo, t)
  end
end

return AllianceRecommendGetRecommendAllianceInfoMessage
