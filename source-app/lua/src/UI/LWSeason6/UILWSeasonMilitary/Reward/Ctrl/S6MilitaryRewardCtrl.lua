local S6MilitaryRewardCtrl = BaseClass("S6MilitaryRewardCtrl", UIBaseCtrl)

function S6MilitaryRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.S6MilitaryReward)
end

return S6MilitaryRewardCtrl
