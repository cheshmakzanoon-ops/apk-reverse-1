local UIZombieBattleHangUpRewardCtrl = BaseClass("UIZombieBattleHangUpRewardCtrl", UIBaseCtrl)

function UIZombieBattleHangUpRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIZombieBattleHangUpReward, {anim = false})
end

function UIZombieBattleHangUpRewardCtrl:InitData(self)
end

return UIZombieBattleHangUpRewardCtrl
