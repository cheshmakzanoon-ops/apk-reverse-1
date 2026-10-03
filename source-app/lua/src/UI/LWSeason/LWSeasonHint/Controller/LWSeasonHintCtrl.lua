local LWSeasonHintCtrl = BaseClass("LWSeasonHintCtrl", UIBaseCtrl)

function LWSeasonHintCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonHint)
end

return LWSeasonHintCtrl
