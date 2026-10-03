local LWSeasonDesertTipCtrl = BaseClass("LWSeasonDesertTipCtrl", UIBaseCtrl)

function LWSeasonDesertTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWSeasonDesertTip)
end

return LWSeasonDesertTipCtrl
