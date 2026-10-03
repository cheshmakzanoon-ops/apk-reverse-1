local AllianceRecommendR4CandidateCheckMessage = BaseClass("AllianceRecommendR4CandidateCheckMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceRecommendR4CandidateCheckMessage:OnCreate(param)
  base.OnCreate(self)
end

function AllianceRecommendR4CandidateCheckMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceMemberDataManager:SetNeedShowR4Recommend(t.needRecommendR4)
    if LuaEntry.DataConfig:CheckSwitch("r4recommend_switch") then
      EventManager:GetInstance():Broadcast(EventId.Al_R4RecommendTips)
    end
  end
end

return AllianceRecommendR4CandidateCheckMessage
