local LWSeasonRewardCtrl = BaseClass("LWSeasonRewardCtrl", UIBaseCtrl)

function LWSeasonRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonReward)
end

return LWSeasonRewardCtrl
