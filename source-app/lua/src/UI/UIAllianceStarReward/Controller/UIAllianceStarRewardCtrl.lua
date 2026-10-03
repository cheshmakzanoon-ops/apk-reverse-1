local UIAllianceStarRewardCtrl = BaseClass("UIAllianceStarRewardCtrl", UIBaseCtrl)

function UIAllianceStarRewardCtrl:CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIAllianceStarReward, {anim = true})
end

return UIAllianceStarRewardCtrl
