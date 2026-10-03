local UIDesertBuildStatusCtrl = BaseClass("UIDesertBuildStatusCtrl", UIBaseCtrl)

function UIDesertBuildStatusCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertBuildStatus)
end

return UIDesertBuildStatusCtrl
