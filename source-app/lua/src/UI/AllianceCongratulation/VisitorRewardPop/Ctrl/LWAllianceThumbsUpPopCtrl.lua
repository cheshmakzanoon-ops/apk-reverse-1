local LWAllianceThumbsUpPopCtrl = BaseClass("LWAllianceThumbsUpPopCtrl", UIBaseCtrl)

function LWAllianceThumbsUpPopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWAllianceThumbsUpPopView)
end

return LWAllianceThumbsUpPopCtrl
