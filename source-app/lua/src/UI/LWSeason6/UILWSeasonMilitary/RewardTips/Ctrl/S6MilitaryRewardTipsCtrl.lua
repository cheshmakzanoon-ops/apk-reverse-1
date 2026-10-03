local S6MilitaryRewardTipsCtrl = BaseClass("S6MilitaryRewardTipsCtrl", UIBaseCtrl)

function S6MilitaryRewardTipsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.S6MilitaryRewardTipsView)
end

return S6MilitaryRewardTipsCtrl
