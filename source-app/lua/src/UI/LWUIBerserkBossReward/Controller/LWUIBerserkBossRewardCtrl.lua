local LWUIBerserkBossRewardCtrl = BaseClass("LWUIBerserkBossRewardCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWUIBerserkBossRewardCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIBerserkBossReward)
end

return LWUIBerserkBossRewardCtrl
