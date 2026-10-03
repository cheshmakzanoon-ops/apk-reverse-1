local AllianceManagerGainRecommendationInfoMessage = BaseClass("AllianceManagerGainRecommendationInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceManagerGainRecommendationInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function AllianceManagerGainRecommendationInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.AllianceGainRecommendationInfo, t)
  end
end

return AllianceManagerGainRecommendationInfoMessage
