local LWUISearchHelperCtrl = BaseClass("LWUISearchHelperCtrl", UIBaseCtrl)

function LWUISearchHelperCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUISearchHelper)
end

return LWUISearchHelperCtrl
