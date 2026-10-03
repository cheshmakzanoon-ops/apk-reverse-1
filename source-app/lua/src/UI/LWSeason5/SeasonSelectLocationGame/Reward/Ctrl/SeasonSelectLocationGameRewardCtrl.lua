local SeasonSelectLocationGameRewardCtrl = BaseClass("SeasonSelectLocationGameRewardCtrl", UIBaseCtrl)

function SeasonSelectLocationGameRewardCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.SeasonSelectLocationGameReward)
end

function SeasonSelectLocationGameRewardCtrl:Close()
  UIManager.Instance:DestroyWindow(UIWindowNames.SeasonSelectLocationGameReward)
end

return SeasonSelectLocationGameRewardCtrl
