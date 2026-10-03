local AllianceRecommendR4CandidateInfoMessage = BaseClass("AllianceRecommendR4CandidateInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceRecommendR4CandidateInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function AllianceRecommendR4CandidateInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceMemberDataManager:UpdateR4RecommendMemberList(t)
    DataCenter.AllianceMemberDataManager:SetNeedShowR4Recommend(false)
    if LuaEntry.DataConfig:CheckSwitch("r4recommend_switch") then
      EventManager:GetInstance():Broadcast(EventId.Al_R4RecommendTips)
    end
  end
end

return AllianceRecommendR4CandidateInfoMessage
