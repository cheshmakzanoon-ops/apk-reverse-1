local LWSeasonWorldCtrl = BaseClass("LWSeasonWorldCtrl", UIBaseCtrl)

function LWSeasonWorldCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWSeasonWorld)
end

return LWSeasonWorldCtrl
