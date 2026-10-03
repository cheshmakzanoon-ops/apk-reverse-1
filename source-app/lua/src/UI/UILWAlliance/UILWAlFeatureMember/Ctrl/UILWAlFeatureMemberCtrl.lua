local UILWAlFeatureMemberCtrl = BaseClass("UILWAlFeatureMemberCtrl", UIBaseCtrl)

function UILWAlFeatureMemberCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlFeatureMember)
end

function UILWAlFeatureMemberCtrl:OnAllianceGainRecommendationInfo(msg)
  self.recommendation = msg.recommendation
  self.remainCount = msg.remainCount or 0
end

function UILWAlFeatureMemberCtrl:OnAllianceRecommendationInvite(msg)
  self.remainCount = msg.remainCount or 0
  if self.recommendation then
    for i, v in ipairs(self.recommendation) do
      if v.roleInfo.uid == msg.targetUid then
        v.isInvited = true
        break
      end
    end
  end
end

return UILWAlFeatureMemberCtrl
