local LWSeasonHintCtrl = BaseClass("LWSeasonHintCtrl", UIBaseCtrl)

function LWSeasonHintCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonUpgradeLog)
end

return LWSeasonHintCtrl
