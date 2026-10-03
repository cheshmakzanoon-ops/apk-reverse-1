local LWPVPArenaRewardCtrl = BaseClass("LWPVPArenaRewardCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWPVPArenaRewardCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWPVPArenaReward)
end

function LWPVPArenaRewardCtrl:Close()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWPVPArenaReward)
end

return LWPVPArenaRewardCtrl
