local UIDesertBuildDetailCtrl = BaseClass("UIDesertBuildDetailCtrl", UIBaseCtrl)

function UIDesertBuildDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertBuildDetail)
end

return UIDesertBuildDetailCtrl
